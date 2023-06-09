require 'json'

json_indexers = File.read(Rails.root.join('db', 'indexers.json'))
data = JSON.parse(json_indexers)
indexers = data['indexers']

json_products = File.read(Rails.root.join('db', 'products.json'))
products = JSON.parse(json_products)

puts "Iniciando seed"
    
indexers.each do |indexer|
    data = Indexers.send(indexer['method'])
  
    begin
      Fee.create!(name: indexer['name'], value: data.last['valor'], latest_release: data.last['data'])
      puts "Indexador #{indexer['name']} adicionado com sucesso!"
    rescue ActiveRecord::RecordInvalid => e
      puts "#{indexer['name']}: #{e.message}"
    end
end

products.each do |product_data|
  product_data['end_of_term'] = Date.today.advance(years: 1) + rand(365)
  product_data['fee'] = Fee.order("RANDOM()").first

  begin
    Product.create!(product_data)
    puts "Produto #{product_data['name']} adicionado com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    puts "#{product_data['name']}: #{e.message}"
  end
end

puts "Finalizou seed"