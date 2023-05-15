class Person < ApplicationRecord
  self.table_name = 'people'
  self.primary_key = 'person_id'
end
