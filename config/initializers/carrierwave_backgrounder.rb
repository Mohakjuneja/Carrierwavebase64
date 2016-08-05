CarrierWave::Backgrounder.configure do |c|
  # c.backend :sidekiq, queue: :carrierwave
  c.backend :active_job, queue: :carrierwave
end
