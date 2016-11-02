Sequel.migration do
  up do
    create_table(:events) do
      primary_key :id
      String      :name
      Date        :date
    end
  end

  down do
    drop_table(:events)
  end
end
