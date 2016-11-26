class BaseWorker
  include Sidekiq::Worker

  sidekiq_options(
    retry: false,
    backtrace: true
  )
end