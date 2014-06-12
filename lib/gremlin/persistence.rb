require 'gremlin/persistence_adapters'

module Gremlin

  class Persistence

    attr_reader :adapter

    def initialize(persistence_adapter)
      @adapter = persistence_adapter
    end

    def find_jobs(options)
      adapter.find_jobs(options).map do |jobs_hash|
        Job.new_from_hash(jobs_hash)
      end
    end

    def load_job(job_id)
      jobs_hash = adapter.load_job(id)
      ExecutionPlan.new_from_hash(jobs_hash, @world)
    end

    def save_job(job)
      adapter.save_job(job.job_id, job.to_hash)
    end

  end
end