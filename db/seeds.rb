require 'json'

json_indexers = File.read(Rails.root.join('db', 'indexers.json'))
indexers = JSON.parse(json_indexers)['indexers']

puts "Iniciando seed"
# Product.create(name: "Teste", punctuation: 1, start_date: Date.current, end_of_term: 6.months.since(Date.current), minimum_investment_amount: 10.00, index: Fee.find_by_name("SELIC").value)
    
indexers.each do |indexer|
    data = Indexers.send(indexer['method'])
  
    begin
      Fee.create!(name: indexer['name'], value: data.last['valor'], latest_release: data.last['data'])
      puts "Indexador #{indexer['name']} adicionado com sucesso!"
    rescue ActiveRecord::RecordInvalid => e
      puts "#{indexer['name']}: #{e.message}"
    end
end

puts "Finalizou seed"
