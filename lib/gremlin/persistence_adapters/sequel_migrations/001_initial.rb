
Sequel.migration do
  up do
    create_table(:gremlin_jobs) do
      column :job_id, String, primary_key: true, size: 36, fixed: true
      index :job_id, :unique => true

      column :data, String, text: true

      column :args, String, text: true
      column :template, String
      column :user, String
      column :schedule, String
      column :plan_id, String
      column :state, String

    end


  end

  down do
    drop_table(:gremlin_jobs)
  end
end