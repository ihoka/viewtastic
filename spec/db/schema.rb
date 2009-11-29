ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.string :login
    t.string :email
  end
  
  create_table :products, :force => true do |t|
    t.string :name
  end
end
