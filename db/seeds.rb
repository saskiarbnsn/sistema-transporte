# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb
#
# Datos de demostración para el Sistema de Gestión de Transporte Agropecuario.
#
# Todos los datos de este archivo son FICTICIOS. CUITs, nombres de personas,
# nombres de establecimientos, patentes, teléfonos y ubicaciones no corresponden
# a personas, empresas ni operaciones reales.
#
# Ejecutar con:  bin/rails db:seed
#
# El seed es idempotente: se puede ejecutar varias veces sin duplicar registros.

puts "Iniciando carga de datos de demostración..."

# ─────────────────────────────────────────────────────────────
# IMPUTACIONES (categorías de gastos)
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando imputaciones..."

%w[Adelantos Administración Combustible Mantenimiento Reparaciones Seguro].each do |nombre|
  imp = Imputation.find_or_create_by!(imputation: nombre)
  puts "   ✓ #{imp.imputation}"
end

# ─────────────────────────────────────────────────────────────
# USUARIOS
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando usuarios de demostración..."

usuarios = [
  {
    email: "admin@demo.com",
    password: "demo123456",
    name: "Administrador",
    surname: "Demo",
    username: "admin"
  },
  {
    email: "operador@demo.com",
    password: "demo123456",
    name: "Operador",
    surname: "Demo",
    username: "operador"
  }
]

usuarios.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.assign_attributes(attrs.merge(password_confirmation: attrs[:password]))
  user.save!
  puts "   ✓ Usuario: #{user.email}"
end

# ─────────────────────────────────────────────────────────────
# CLIENTES (productores agropecuarios)
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando clientes..."

clientes = [
  { cuit: "20-23456789-1", name: "Mariano Fernández Villar" },
  { cuit: "27-18234567-4", name: "Patricia Castelli" },
  { cuit: "30-71234567-8", name: "Pampa Verde SRL" },
  { cuit: "20-21987654-3", name: "Hugo Marín" },
  { cuit: "27-25678901-2", name: "María Inés Bonpland" },
  { cuit: "20-19876543-7", name: "Aníbal Verdusco" }
]

clientes.each do |attrs|
  customer = Customer.find_or_create_by!(cuit: attrs[:cuit]) do |c|
    c.name = attrs[:name]
  end
  puts "   ✓ Cliente: #{customer.name} (CUIT #{customer.cuit})"
end

# ─────────────────────────────────────────────────────────────
# CAMPOS (uno o dos por cliente)
# Ubicaciones reales del sur de Córdoba (coordenadas de localidades existentes
# pero asignadas a establecimientos ficticios).
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando campos..."

campos_por_cliente = {
  "20-23456789-1" => [
    { name: "Establecimiento La Aurora",   province: "Córdoba", latitude: -34.0167, longitude: -63.9333 },
    { name: "La Aurora - Lote Sur",        province: "Córdoba", latitude: -34.0500, longitude: -63.9500 }
  ],
  "27-18234567-4" => [
    { name: "Estancia San Miguel",         province: "Córdoba", latitude: -33.6500, longitude: -64.0667 }
  ],
  "30-71234567-8" => [
    { name: "Pampa Norte",                 province: "Córdoba", latitude: -32.8167, longitude: -63.8667 },
    { name: "Pampa Sur",                   province: "Córdoba", latitude: -33.4167, longitude: -63.3000 }
  ],
  "20-21987654-3" => [
    { name: "Los Algarrobos",              province: "Córdoba", latitude: -33.9000, longitude: -64.4000 }
  ],
  "27-25678901-2" => [
    { name: "El Cardo Azul",               province: "Córdoba", latitude: -34.1300, longitude: -63.3833 }
  ],
  "20-19876543-7" => [
    { name: "Don Aníbal - Las Lomitas",    province: "Córdoba", latitude: -34.8333, longitude: -64.3667 },
    { name: "Don Aníbal - La Esperanza",   province: "Córdoba", latitude: -34.7500, longitude: -64.2500 }
  ]
}

campos_por_cliente.each do |cuit, lista_campos|
  cliente = Customer.find_by!(cuit: cuit)
  lista_campos.each do |attrs|
    field = Field.find_or_create_by!(name: attrs[:name], customer: cliente) do |f|
      f.province  = attrs[:province]
      f.latitude  = attrs[:latitude]
      f.longitude = attrs[:longitude]
    end
    puts "   ✓ Campo: #{field.name}  →  #{cliente.name}"
  end
end

# ─────────────────────────────────────────────────────────────
# DESTINOS (puertos y acopios típicos del cordón cerealero)
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando destinos..."

destinos = [
  { cuit: "30-50001234-5", name: "Terminal Puerto Rosario",        location: "Rosario, Santa Fe",            latitude: -32.9587, longitude: -60.6310 },
  { cuit: "30-50001235-3", name: "Puerto General San Martín",      location: "Puerto General San Martín, Santa Fe", latitude: -32.7167, longitude: -60.7333 },
  { cuit: "30-50001236-1", name: "Puerto Timbúes",                 location: "Timbúes, Santa Fe",            latitude: -32.6833, longitude: -60.7167 },
  { cuit: "30-50001237-0", name: "Acopio La Carlota",              location: "La Carlota, Córdoba",          latitude: -33.4167, longitude: -63.3000 },
  { cuit: "30-50001238-8", name: "Acopio Río Cuarto Centro",       location: "Río Cuarto, Córdoba",          latitude: -33.1228, longitude: -64.3493 },
  { cuit: "30-50001239-6", name: "Terminal San Lorenzo",           location: "San Lorenzo, Santa Fe",        latitude: -32.7461, longitude: -60.7383 }
]

destinos.each do |attrs|
  destination = Destination.find_or_create_by!(cuit: attrs[:cuit]) do |d|
    d.name      = attrs[:name]
    d.location  = attrs[:location]
    d.latitude  = attrs[:latitude]
    d.longitude = attrs[:longitude]
  end
  puts "   ✓ Destino: #{destination.name}"
end

# ─────────────────────────────────────────────────────────────
# CHOFERES (cuatro choferes, como la empresa real)
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando choferes..."

choferes = [
  {
    cuit:                  "20-22345678-9",
    name:                  "Sebastián Acuña",
    birth_date:            Date.new(1978, 4, 12),
    phone_number:          "3385412345",
    location:              "Belgrano 450, General Levalle, Córdoba",
    licencia_vencimiento:  Date.today + 8.months,
    aptofisico:            true,
    apto_vencimiento:      Date.today + 5.months,
    latitude:              -34.0167,
    longitude:             -63.9333
  },
  {
    cuit:                  "20-25678912-3",
    name:                  "Diego Roldán",
    birth_date:            Date.new(1985, 9, 3),
    phone_number:          "3385498765",
    location:              "San Martín 1200, Vicuña Mackenna, Córdoba",
    licencia_vencimiento:  Date.today + 14.months,
    aptofisico:            true,
    apto_vencimiento:      Date.today + 11.months,
    latitude:              -33.9000,
    longitude:             -64.4000
  },
  {
    cuit:                  "20-19234567-5",
    name:                  "Mauricio Pereyra",
    birth_date:            Date.new(1971, 12, 28),
    phone_number:          "3585432109",
    location:              "Sarmiento 88, Laboulaye, Córdoba",
    licencia_vencimiento:  Date.today + 3.weeks,  # próximo a vencer → dispara alerta
    aptofisico:            true,
    apto_vencimiento:      Date.today + 7.months,
    latitude:              -34.1300,
    longitude:             -63.3833
  },
  {
    cuit:                  "20-28765432-1",
    name:                  "Lucas Mansilla",
    birth_date:            Date.new(1990, 6, 17),
    phone_number:          "3385445566",
    location:              "Mitre 720, Adelia María, Córdoba",
    licencia_vencimiento:  Date.today + 18.months,
    aptofisico:            true,
    apto_vencimiento:      Date.today + 25.days,  # próximo a vencer → dispara alerta
    latitude:              -33.6500,
    longitude:             -64.0667
  }
]

choferes.each do |attrs|
  driver = Driver.find_or_create_by!(cuit: attrs[:cuit]) do |d|
    d.assign_attributes(attrs)
  end
  puts "   ✓ Chofer: #{driver.name} (CUIT #{driver.cuit})"
end

# ─────────────────────────────────────────────────────────────
# CAMIONES (cuatro unidades, marcas y modelos variados)
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando camiones..."

camiones = [
  {
    plate:              "AAA123",
    brand:              "Mercedes-Benz",
    model:              "Axor 2644",
    capacity:           30000.0,
    fuel:               "Gasoil",
    kilometres:         485000.0,
    service_kilometres: 21500.0   # > 20.000 km desde el último service → dispara alerta
  },
  {
    plate:              "AB234CD",
    brand:              "Scania",
    model:              "G410",
    capacity:           32000.0,
    fuel:               "Gasoil",
    kilometres:         210000.0,
    service_kilometres: 8400.0
  },
  {
    plate:              "BCD456",
    brand:              "Iveco",
    model:              "Stralis 460",
    capacity:           30000.0,
    fuel:               "Gasoil",
    kilometres:         342000.0,
    service_kilometres: 18900.0   # cerca del límite de 20.000 km, todavía sin alerta
  },
  {
    plate:              "EFG789",
    brand:              "Volvo",
    model:              "FH 540",
    capacity:           32000.0,
    fuel:               "Gasoil",
    kilometres:         128000.0,
    service_kilometres: 3100.0
  }
]

camiones.each do |attrs|
  truck = Truck.find_or_create_by!(plate: attrs[:plate]) do |t|
    t.assign_attributes(attrs)
  end
  puts "   ✓ Camión: #{truck.plate} - #{truck.brand} #{truck.model}"
end

# ─────────────────────────────────────────────────────────────
# VIAJES (variados, distribuidos en los últimos meses)
# Productos típicos: soja, maíz, trigo, girasol.
# Tarifas y pesos realistas dentro del rango de la actividad.
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando viajes..."

# Helper para obtener referencias por nombre/patente sin repetir consultas largas
clientes_db = Customer.all.index_by(&:name)
campos_db   = Field.all.index_by(&:name)
destinos_db = Destination.all.index_by(&:name)
choferes_db = Driver.all.index_by(&:name)
camiones_db = Truck.all.index_by(&:plate)

def crear_viaje(args)
  attrs = {
    customer:    args[:customer],
    field:       args[:field],
    destination: args[:destination],
    driver:      args[:driver],
    truck:       args[:truck],
    product:     args[:product],
    weight:      args[:weight],
    kilometres:  args[:kilometres],
    tariff:      args[:tariff],
    date:        args[:date],
    date_end:    args[:date_end],
    estado:      args[:estado]
  }
  attrs[:net]        = (attrs[:tariff] * attrs[:weight] / 1000.0).round(2)
  attrs[:importeiva] = (attrs[:net] * 1.21).round(2)

  # Evita duplicar si se vuelve a correr el seed (busca por combinación natural)
  existing = Trip.find_by(
    customer: attrs[:customer], field: attrs[:field], destination: attrs[:destination],
    driver: attrs[:driver], truck: attrs[:truck], date: attrs[:date], product: attrs[:product]
  )
  return existing if existing

  Trip.create!(attrs)
end

viajes = [
  # ── Soja: campañas de cosecha gruesa
  {
    customer:    clientes_db["Mariano Fernández Villar"],
    field:       campos_db["Establecimiento La Aurora"],
    destination: destinos_db["Terminal Puerto Rosario"],
    driver:      choferes_db["Sebastián Acuña"],
    truck:       camiones_db["AAA123"],
    product:     "Soja",
    weight:      29500,
    kilometres:  410,
    tariff:      48500,
    date:        Date.today - 95.days,
    date_end:    Date.today - 94.days,
    estado:      false
  },
  {
    customer:    clientes_db["Patricia Castelli"],
    field:       campos_db["Estancia San Miguel"],
    destination: destinos_db["Puerto General San Martín"],
    driver:      choferes_db["Diego Roldán"],
    truck:       camiones_db["AB234CD"],
    product:     "Soja",
    weight:      31000,
    kilometres:  445,
    tariff:      49200,
    date:        Date.today - 88.days,
    date_end:    Date.today - 87.days,
    estado:      false
  },
  {
    customer:    clientes_db["Pampa Verde SRL"],
    field:       campos_db["Pampa Norte"],
    destination: destinos_db["Puerto Timbúes"],
    driver:      choferes_db["Mauricio Pereyra"],
    truck:       camiones_db["BCD456"],
    product:     "Soja",
    weight:      30200,
    kilometres:  385,
    tariff:      47800,
    date:        Date.today - 82.days,
    date_end:    Date.today - 81.days,
    estado:      false
  },
  {
    customer:    clientes_db["Hugo Marín"],
    field:       campos_db["Los Algarrobos"],
    destination: destinos_db["Acopio Río Cuarto Centro"],
    driver:      choferes_db["Lucas Mansilla"],
    truck:       camiones_db["EFG789"],
    product:     "Soja",
    weight:      28500,
    kilometres:  98,
    tariff:      28000,
    date:        Date.today - 76.days,
    date_end:    Date.today - 76.days,
    estado:      false
  },

  # ── Maíz
  {
    customer:    clientes_db["Aníbal Verdusco"],
    field:       campos_db["Don Aníbal - Las Lomitas"],
    destination: destinos_db["Terminal Puerto Rosario"],
    driver:      choferes_db["Sebastián Acuña"],
    truck:       camiones_db["AAA123"],
    product:     "Maíz",
    weight:      30000,
    kilometres:  520,
    tariff:      51000,
    date:        Date.today - 68.days,
    date_end:    Date.today - 67.days,
    estado:      false
  },
  {
    customer:    clientes_db["María Inés Bonpland"],
    field:       campos_db["El Cardo Azul"],
    destination: destinos_db["Terminal San Lorenzo"],
    driver:      choferes_db["Diego Roldán"],
    truck:       camiones_db["AB234CD"],
    product:     "Maíz",
    weight:      31500,
    kilometres:  475,
    tariff:      50200,
    date:        Date.today - 62.days,
    date_end:    Date.today - 61.days,
    estado:      false
  },
  {
    customer:    clientes_db["Pampa Verde SRL"],
    field:       campos_db["Pampa Sur"],
    destination: destinos_db["Acopio La Carlota"],
    driver:      choferes_db["Lucas Mansilla"],
    truck:       camiones_db["EFG789"],
    product:     "Maíz",
    weight:      29000,
    kilometres:  85,
    tariff:      26500,
    date:        Date.today - 55.days,
    date_end:    Date.today - 55.days,
    estado:      false
  },

  # ── Trigo (cosecha fina)
  {
    customer:    clientes_db["Mariano Fernández Villar"],
    field:       campos_db["La Aurora - Lote Sur"],
    destination: destinos_db["Puerto General San Martín"],
    driver:      choferes_db["Mauricio Pereyra"],
    truck:       camiones_db["BCD456"],
    product:     "Trigo",
    weight:      28500,
    kilometres:  430,
    tariff:      48800,
    date:        Date.today - 48.days,
    date_end:    Date.today - 47.days,
    estado:      false
  },
  {
    customer:    clientes_db["Hugo Marín"],
    field:       campos_db["Los Algarrobos"],
    destination: destinos_db["Acopio Río Cuarto Centro"],
    driver:      choferes_db["Sebastián Acuña"],
    truck:       camiones_db["AAA123"],
    product:     "Trigo",
    weight:      27800,
    kilometres:  105,
    tariff:      27500,
    date:        Date.today - 42.days,
    date_end:    Date.today - 42.days,
    estado:      false
  },
  {
    customer:    clientes_db["Aníbal Verdusco"],
    field:       campos_db["Don Aníbal - La Esperanza"],
    destination: destinos_db["Puerto Timbúes"],
    driver:      choferes_db["Diego Roldán"],
    truck:       camiones_db["AB234CD"],
    product:     "Trigo",
    weight:      30500,
    kilometres:  490,
    tariff:      50500,
    date:        Date.today - 35.days,
    date_end:    Date.today - 34.days,
    estado:      false
  },

  # ── Girasol
  {
    customer:    clientes_db["Patricia Castelli"],
    field:       campos_db["Estancia San Miguel"],
    destination: destinos_db["Terminal Puerto Rosario"],
    driver:      choferes_db["Lucas Mansilla"],
    truck:       camiones_db["EFG789"],
    product:     "Girasol",
    weight:      26000,
    kilometres:  455,
    tariff:      49500,
    date:        Date.today - 28.days,
    date_end:    Date.today - 27.days,
    estado:      false
  },
  {
    customer:    clientes_db["María Inés Bonpland"],
    field:       campos_db["El Cardo Azul"],
    destination: destinos_db["Acopio La Carlota"],
    driver:      choferes_db["Mauricio Pereyra"],
    truck:       camiones_db["BCD456"],
    product:     "Girasol",
    weight:      25500,
    kilometres:  92,
    tariff:      26800,
    date:        Date.today - 21.days,
    date_end:    Date.today - 21.days,
    estado:      false
  },

  # ── Viajes recientes (último mes)
  {
    customer:    clientes_db["Pampa Verde SRL"],
    field:       campos_db["Pampa Norte"],
    destination: destinos_db["Terminal San Lorenzo"],
    driver:      choferes_db["Sebastián Acuña"],
    truck:       camiones_db["AAA123"],
    product:     "Soja",
    weight:      30000,
    kilometres:  420,
    tariff:      52000,
    date:        Date.today - 14.days,
    date_end:    Date.today - 13.days,
    estado:      false
  },
  {
    customer:    clientes_db["Mariano Fernández Villar"],
    field:       campos_db["Establecimiento La Aurora"],
    destination: destinos_db["Puerto General San Martín"],
    driver:      choferes_db["Diego Roldán"],
    truck:       camiones_db["AB234CD"],
    product:     "Maíz",
    weight:      31000,
    kilometres:  440,
    tariff:      53000,
    date:        Date.today - 9.days,
    date_end:    Date.today - 8.days,
    estado:      false
  },

  # ── Viajes en curso (todavía no terminaron)
  {
    customer:    clientes_db["Hugo Marín"],
    field:       campos_db["Los Algarrobos"],
    destination: destinos_db["Puerto Timbúes"],
    driver:      choferes_db["Lucas Mansilla"],
    truck:       camiones_db["EFG789"],
    product:     "Trigo",
    weight:      29500,
    kilometres:  465,
    tariff:      53500,
    date:        Date.today - 1.day,
    date_end:    nil,
    estado:      true
  },
  {
    customer:    clientes_db["Aníbal Verdusco"],
    field:       campos_db["Don Aníbal - Las Lomitas"],
    destination: destinos_db["Terminal Puerto Rosario"],
    driver:      choferes_db["Mauricio Pereyra"],
    truck:       camiones_db["BCD456"],
    product:     "Soja",
    weight:      30800,
    kilometres:  535,
    tariff:      54000,
    date:        Date.today,
    date_end:    nil,
    estado:      true
  }
]

viajes.each do |v|
  trip = crear_viaje(v)
  puts "   ✓ Viaje: #{trip.product} | #{trip.customer.name} → #{trip.destination.name} | #{trip.weight.to_i} kg"
end

# ─────────────────────────────────────────────────────────────
# GASTOS (uno por cada imputación, cubriendo todos los atributos)
#
# El modelo Gasto calcula solo el desglose impositivo (gravado / net / iva)
# en un before_save, así que acá NO se cargan esos campos a mano.
#
#   • Combustible  → desglosa gravado/net/iva y guarda los litros
#   • Mantenimiento→ dispara el callback que crea un TruckService asociado
#   • Adelanto     → se vincula a un chofer y usa el campo "adelantos"
#   • Los flags truck_disabled / driver_disabled muestran gastos cuyo
#     camión o chofer quedó dado de baja pero el comprobante se conserva.
# ─────────────────────────────────────────────────────────────
puts "\n→ Creando gastos..."

imputaciones_db = Imputation.all.index_by(&:imputation)

def crear_gasto(attrs)
  # Idempotente: la combinación imputación + fecha + total + proveedor
  # alcanza para no duplicar al re-ejecutar el seed.
  Gasto.find_or_create_by!(
    imputation: attrs[:imputation],
    date:       attrs[:date],
    total:      attrs[:total],
    supplier:   attrs[:supplier]
  ) do |g|
    g.assign_attributes(attrs)
  end
end

gastos = [
  # ── Combustible (con litros → desglosa gravado/net/iva)
  {
    imputation:  imputaciones_db["Combustible"],
    truck:       camiones_db["AAA123"],
    supplier:    "YPF Ruta 8",
    description: "Carga de gasoil grado 2",
    litros:      480,
    total:       1_080_000,
    date:        Date.today - 120.days
  },
  {
    imputation:  imputaciones_db["Combustible"],
    truck:       camiones_db["AB234CD"],
    supplier:    "Shell Río Cuarto",
    description: "Carga de gasoil",
    litros:      510,
    total:       1_150_000,
    date:        Date.today - 70.days
  },
  {
    imputation:  imputaciones_db["Combustible"],
    truck:       camiones_db["EFG789"],
    supplier:    "Axion General Levalle",
    description: "Carga de gasoil",
    litros:      360,
    total:       820_000,
    date:        Date.today - 18.days
  },
  # Combustible sin camión asignado y con el camión dado de baja (flag truck_disabled)
  {
    imputation:     imputaciones_db["Combustible"],
    truck:          nil,
    truck_disabled: true,
    supplier:       "Estación de servicio (unidad de terceros)",
    description:    "Carga eventual, unidad no propia",
    litros:         300,
    total:          690_000,
    date:           Date.today - 40.days
  },

  # ── Mantenimiento (dispara la creación automática de un TruckService)
  {
    imputation:  imputaciones_db["Mantenimiento"],
    truck:       camiones_db["EFG789"],
    supplier:    "Taller Diésel del Sur",
    description: "Cambio de aceite y filtros",
    total:       340_000,
    date:        Date.today - 95.days
  },
  {
    imputation:  imputaciones_db["Mantenimiento"],
    truck:       camiones_db["AB234CD"],
    supplier:    "Servicio Scania Córdoba",
    description: "Service programado de 200.000 km",
    total:       920_000,
    date:        Date.today - 50.days
  },

  # ── Reparaciones
  {
    imputation:  imputaciones_db["Reparaciones"],
    truck:       camiones_db["AAA123"],
    supplier:    "Gomería El Cruce",
    description: "Cambio de dos cubiertas de tracción",
    total:       1_480_000,
    date:        Date.today - 60.days
  },
  {
    imputation:  imputaciones_db["Reparaciones"],
    truck:       camiones_db["BCD456"],
    supplier:    "Electromecánica Vidal",
    description: "Reparación de alternador",
    total:       265_000,
    date:        Date.today - 25.days
  },

  # ── Seguro (sin camión ni chofer puntual; gasto de flota)
  {
    imputation:  imputaciones_db["Seguro"],
    supplier:    "La Segunda Seguros",
    description: "Póliza de flota - cuota mensual",
    total:       480_000,
    date:        Date.today - 88.days
  },
  {
    imputation:  imputaciones_db["Seguro"],
    supplier:    "La Segunda Seguros",
    description: "Póliza de flota - cuota mensual",
    total:       495_000,
    date:        Date.today - 30.days
  },

  # ── Administración (uno con descripción, otro sin proveedor ni descripción)
  {
    imputation:  imputaciones_db["Administración"],
    supplier:    "Estudio Contable Pérez",
    description: "Honorarios contables",
    total:       220_000,
    date:        Date.today - 75.days
  },
  {
    imputation:  imputaciones_db["Administración"],
    supplier:    nil,
    description: nil,
    total:       38_500,
    date:        Date.today - 12.days
  },

  # ── Adelanto (vinculado a un chofer, usa el campo "adelantos")
  {
    imputation:  imputaciones_db["Adelantos"],
    driver:      choferes_db["Sebastián Acuña"],
    adelantos:   "Adelanto quincenal",
    description: "A cuenta de liquidación",
    total:       350_000,
    date:        Date.today - 45.days
  },
  {
    imputation:  imputaciones_db["Adelantos"],
    driver:      choferes_db["Diego Roldán"],
    adelantos:   "Adelanto de viáticos",
    description: "Viáticos viaje a puerto",
    total:       180_000,
    date:        Date.today - 20.days
  },
  # Adelanto cuyo chofer quedó dado de baja (flag driver_disabled)
  {
    imputation:     imputaciones_db["Adelantos"],
    driver:         nil,
    driver_disabled: true,
    adelantos:      "Adelanto chofer eventual",
    description:    "Chofer ya no activo",
    total:          120_000,
    date:           Date.today - 8.days
  }
]

gastos.each do |g|
  gasto = crear_gasto(g)
  etiqueta = gasto.imputation.imputation
  unidad   = gasto.truck&.plate || gasto.driver&.name || "—"
  puts "   ✓ Gasto: #{etiqueta} | #{unidad} | $#{gasto.total.to_i}"
end

# ─────────────────────────────────────────────────────────────
# RESUMEN FINAL
# ─────────────────────────────────────────────────────────────
puts "\n" + ("═" * 60)
puts "✓ Datos de demostración cargados correctamente"
puts "═" * 60
puts "  Usuarios:   #{User.count}"
puts "  Clientes:   #{Customer.count}"
puts "  Campos:     #{Field.count}"
puts "  Destinos:   #{Destination.count}"
puts "  Choferes:   #{Driver.count}"
puts "  Camiones:   #{Truck.count}"
puts "  Viajes:     #{Trip.count}"
puts "  Gastos:     #{Gasto.count}"
puts "  Servicios:  #{TruckService.count}  (generados por gastos de Mantenimiento)"
puts "  Imputac.:   #{Imputation.count}"
puts "═" * 60
puts "\nCredenciales de acceso:"
puts "  admin@demo.com     /  demo123456   (administrador)"
puts "  operador@demo.com  /  demo123456   (operador)"
puts "\nLos datos cargados son ficticios y no representan personas,"
puts "empresas ni operaciones reales."
puts ""