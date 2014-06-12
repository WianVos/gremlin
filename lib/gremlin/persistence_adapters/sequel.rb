require 'sequel/no_core_ext' # to avoid sequel ~> 3.0 coliding with ActiveRecord
require 'multi_json'

module Gremlin
  module PersistenceAdapters

    Sequel.extension :migration

    class Sequel < Abstract
      include Algebrick::TypeCheck

      attr_reader :db

      def pagination?
        true
      end

      def filtering_by
        META_DATA.fetch :job
      end

      def ordering_by
        META_DATA.fetch :job
      end

      META_DATA = { job: %w(job_id state template user schedule plan_id)}
      #META_DATA = { job: %w(job_id args template user schedule plan_id)}


      def initialize(db_path)
        @db = initialize_db db_path
        migrate_db
      end

      def find_jobs(options = {})
        data_set = filter(order(paginate(table(:job), options), options), options)

        data_set.map do |record|
          HashWithIndifferentAccess.new(MultiJson.load(record[:data]))
        end
      end

      def load_job(job_id)
        load :job, job_id: job_id
      end

      def save_job(job_id, value)
        save :job, { job_id: job_id }, value
      end


      def to_hash
        { jobs: table(:job).all}
      end

      private

      TABLES = { job: :gremlin_jobs }


      def table(which)
        db[TABLES.fetch(which)]
      end

      def initialize_db(db_path)
        ::Sequel.connect db_path
      end

      def self.migrations_path
        File.expand_path('../sequel_migrations', __FILE__)
      end

      def migrate_db
        ::Sequel::Migrator.run(db, self.class.migrations_path)
      end

      def save(what, condition, value)
        table           = table(what)
        existing_record = table.first condition

        if value
          value         = value.with_indifferent_access
          record        = existing_record || condition
          record[:data] = MultiJson.dump Type!(value, Hash)
          meta_data     = META_DATA.fetch(what).inject({}) { |h, k| h.update k.to_sym => value.fetch(k) }
          record.merge! meta_data
          record.each { |k, v| record[k] = v.to_s if v.is_a? Symbol }

          if existing_record
            table.where(condition).update(record)
          else
            table.insert record
          end

        else
          existing_record and table.where(condition).delete
        end
        value
      end

      def load(what, condition)
        table = table(what)
        if (record = table.first(condition.symbolize_keys))
          HashWithIndifferentAccess.new MultiJson.load(record[:data])
        else
          raise KeyError, "searching: #{what} by: #{condition.inspect}"
        end
      end

      def paginate(data_set, options)
        page     = Integer(options[:page] || 0)
        per_page = Integer(options[:per_page] || 20)

        if page
          data_set.limit per_page, per_page * page
        else
          data_set
        end
      end

      def order(data_set, options)
        order_by = (options[:order_by] || :state).to_s

        order_by = order_by.to_sym
        data_set.order_by options[:desc] ? ::Sequel.desc(order_by) : order_by
      end

      def filter(data_set, options)
        filters = Type! options[:filters], NilClass, Hash
        return data_set if filters.nil?

        unless (unknown = filters.keys - META_DATA.fetch(:job)).empty?
          raise ArgumentError, "unkown columns: #{unknown.inspect}"
        end

        data_set.where filters.symbolize_keys
      end
    end
  end
end