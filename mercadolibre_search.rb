# frozen_string_literal: true

# ===================================================================
# Script de Automatización para Mercado Libre (Versión Final con Evidencias)
# ===================================================================

require 'appium_lib'
require 'set'
require 'fileutils' # Requerimos 'fileutils' para la creación de directorios

# --- Constantes de Configuración ---
SEARCH_TERM = 'playstation 5'
WAIT_TIMEOUT = 30
SHORT_PAUSE = 2
LONG_PAUSE = 5
EVIDENCES_DIR = 'evidences'.freeze # Nombre de la carpeta para las capturas

# Localizadores (textos y IDs a buscar en la UI)
LOCATORS = {
  visitor_button: "//*[@text='Continuar como visitante']",
  search_field: 'com.mercadolibre:id/ui_components_toolbar_search_field',
  edit_text_field: 'android.widget.EditText',
  filters_button: "//*[contains(@text, 'Filtros')]",
  condition_filter: "//*[@text='Condición']",
  new_option: "//*[@text='Nuevo']",
  pickup_filter: "//*[@text='Retiro gratis']",
  location_option: "//*[@text='Bogotá D.C.']",
  sort_filter: "//*[@text='Ordenar por']",
  price_option: "//*[@text='Mayor precio']",
  apply_filters_button: "//*[contains(@text, 'Ver ')]",
}.freeze

# ===================================================================
#                            Funciones de Ayuda
# ===================================================================

# Función de scroll ÚNICA y ROBUSTA para todo el script.
def perform_scroll_up(driver)
  puts '  -> Deslizando pantalla...'
  window_size = driver.window_rect
  start_x = window_size.width / 2
  start_y = window_size.height * 0.8
  end_y = window_size.height * 0.2
  
  finger = driver.action
  finger.move_to_location(start_x, start_y)
        .pointer_down(:touch)
        .move_to_location(start_x, end_y, duration: 0.5)
        .pointer_up(:touch)
  finger.perform
end

# Función principal que busca un elemento, haciendo scroll si es necesario.
def find_with_scroll(driver, wait, type, value, max_swipes = 8)
  attempts = 0
  while attempts < max_swipes
    begin
      element = driver.find_element(type, value)
      return element if element.displayed?
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts "  -> Elemento '#{value}' no visible. Buscando..."
      perform_scroll_up(driver)
      sleep 1.5
      attempts += 1
    end
  end
  raise "Elemento no encontrado después de #{max_swipes} intentos: '#{value}'"
end

# NUEVA FUNCIÓN para tomar y guardar capturas de pantalla.
def take_screenshot(driver, step_counter, description)
  # Limpiamos la descripción para que sea un nombre de archivo válido.
  filename_desc = description.downcase.gsub(/[^a-z0-9\-_]+/, '_')
  filepath = File.join(EVIDENCES_DIR, "#{step_counter.to_s.rjust(2, '0')}_#{filename_desc}.png")
  
  driver.screenshot(filepath)
  puts "  -> Captura de pantalla guardada en: #{filepath}"
end


# ===================================================================
#                        Flujo Principal del Script
# ===================================================================

def main
  caps = {
    caps: {
      platformName: 'Android',
      deviceName: 'Android Device',
      automationName: 'UiAutomator2',
      appPackage: 'com.mercadolibre',
      appWaitActivity: '*',
      newCommandTimeout: 300,
      autoGrantPermissions: true
    },
    appium_lib: { server_url: 'http://localhost:4723' }
  }

  # --- Preparación del Entorno ---
  # Se asegura de que la carpeta de evidencias exista.
  FileUtils.mkdir_p(EVIDENCES_DIR) unless File.directory?(EVIDENCES_DIR)
  step_counter = 0

  puts 'Iniciando driver de Appium...'
  driver = Appium::Driver.new(caps, true)
  driver.start_driver
  wait = Selenium::WebDriver::Wait.new(timeout: WAIT_TIMEOUT)
  puts 'Driver iniciado correctamente.'
  sleep LONG_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '0_app_iniciada')


  # --- [Pasos 1-7] Navegación y Filtros ---
  puts "\n[Paso 1] Ingresando como visitante..."
  begin
    wait.until { driver.find_element(:xpath, LOCATORS[:visitor_button]) }.click
    puts '-> Se hizo clic en "Continuar como visitante".'
  rescue StandardError
    puts '-> No fue necesario ingresar como visitante.'
  end
  sleep SHORT_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '1_ingreso_visitante')
  
  puts "\n[Paso 2] Buscando '#{SEARCH_TERM}'..."
  wait.until { driver.find_element(:id, LOCATORS[:search_field]) }.click
  editable_field = wait.until { driver.find_element(:class_name, LOCATORS[:edit_text_field]) }
  editable_field.send_keys(SEARCH_TERM)
  driver.press_keycode(66)
  puts '-> Búsqueda enviada.'
  sleep LONG_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '2_resultados_busqueda')

  puts "\n[Paso 3] Abriendo menú de filtros..."
  wait.until { driver.find_element(:xpath, LOCATORS[:filters_button]) }.click
  puts '-> Esperando a que el modal de filtros se estabilice...'
  sleep 4
  step_counter += 1
  take_screenshot(driver, step_counter, '3_modal_filtros_abierto')
  
  puts "\n[Paso 4] Aplicando filtro de Condición..."
  find_with_scroll(driver, wait, :xpath, LOCATORS[:condition_filter]).click
  wait.until { driver.find_element(:xpath, LOCATORS[:new_option]) }.click
  sleep SHORT_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '4_filtro_condicion_aplicado')
  
  puts "\n[Paso 5] Aplicando filtro de Ubicación..."
  find_with_scroll(driver, wait, :xpath, LOCATORS[:pickup_filter]).click
  wait.until { driver.find_element(:xpath, LOCATORS[:location_option]) }.click
  sleep SHORT_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '5_filtro_ubicacion_aplicado')
  
  puts "\n[Paso 6] Aplicando filtro de Ordenamiento..."
  find_with_scroll(driver, wait, :xpath, LOCATORS[:sort_filter]).click
  wait.until { driver.find_element(:xpath, LOCATORS[:price_option]) }.click
  sleep SHORT_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '6_filtro_ordenar_aplicado')

  puts "\n[Paso 7] Confirmando todos los filtros..."
  wait.until { driver.find_element(:xpath, LOCATORS[:apply_filters_button]) }.click
  puts '-> Filtros aplicados.'
  sleep LONG_PAUSE
  step_counter += 1
  take_screenshot(driver, step_counter, '7_resultados_finales_filtrados')

  # --- [Paso 8] Extracción de Resultados ---
  puts "\n[Paso 8] Recolectando los 5 primeros productos..."
  
  results = []
  processed_titles = Set.new
  attempts = 0
  max_scrolls = 4

  while results.size < 5 && attempts <= max_scrolls
    puts "-> Analizando pantalla. Productos recolectados: #{results.size}/5."
    items_before_pass = processed_titles.size
    
    product_card_xpath = "//android.widget.RelativeLayout[.//android.widget.TextView[starts-with(@text, '$')]]"
    wait.until { !driver.find_elements(:xpath, product_card_xpath).empty? }
    product_cards = driver.find_elements(:xpath, product_card_xpath)

    product_cards.each do |card|
      break if results.size >= 5
      begin
        text_elements = card.find_elements(:class_name, 'android.widget.TextView')
        price_element = text_elements.find { |el| el.text.start_with?('$') }
        title_element = text_elements.find { |el| el.text.length > 15 && !el.text.start_with?('$') && !el.text.downcase.include?('cuotas') && !el.text.downcase.include?('opción') }
        
        if title_element && price_element
          title = title_element.text
          if processed_titles.add?(title)
            price = price_element.text.gsub(/[^\d\$\.\,]/, '')
            results << { title: title, price: price }
            puts "  [+] Recolectado: #{title}"
          end
        end
      rescue StandardError
      end
    end
    
    break if results.size >= 5
    
    items_after_pass = processed_titles.size
    if items_after_pass == items_before_pass
      puts "  -> No se encontraron más productos nuevos en la pantalla. Deteniendo búsqueda."
      break
    end
    
    perform_scroll_up(driver)
    attempts += 1
    sleep 2
  end

  puts '-------------------------------------------'
  puts '             RESULTADOS FINALES'
  if results.empty?
    puts "No se pudieron recolectar los productos."
  else
    results.first(5).each_with_index do |result, i|
      puts "#{i + 1}. #{result[:title]} - #{result[:price]}"
    end
  end
  puts '-------------------------------------------'

rescue StandardError => e
  puts "\n[ERROR CRÍTICO] El script falló: #{e.class} - #{e.message}"
  puts "Backtrace:\n#{e.backtrace.join("\n")}"
  # La captura de error ahora también va a la carpeta de evidencias
  error_filepath = File.join(EVIDENCES_DIR, "error_fatal_#{Time.now.to_i}.png")
  driver.screenshot(error_filepath)
  puts "Captura de pantalla del error guardada en: #{error_filepath}"
ensure
  puts "\n[Final] Cerrando la sesión del driver."
  driver.driver_quit if driver
end

# --- Punto de Entrada del Script ---
main