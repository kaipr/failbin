namespace :fetcher do

  desc "Fetches emails and import them"
  task :fetch_mails => :environment do
    MailFetcher.new.fetch_mails
  end

  desc "Destroy all fetched data"
  task :destroy_fetched => :environment do
    ErrorType.destroy_all
    Error.destroy_all
  end

end