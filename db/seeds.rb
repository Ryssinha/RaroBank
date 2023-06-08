require 'json'

json_indexers = File.read(Rails.root.join('db', 'indexers.json'))
indexers = JSON.parse(json_indexers)['indexers']

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

puts "Finalizou seed"
