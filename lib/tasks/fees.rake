namespace :fees do
    desc 'Update fee in database'
    task update_fee_in_database: :environment do
        UpdateFeesValuesAndDate.perform_now
    end
end