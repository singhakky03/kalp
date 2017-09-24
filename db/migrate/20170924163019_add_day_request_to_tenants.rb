class AddDayRequestToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :day_requests, :integer, default: 0
    add_column :tenants, :total_requests, :integer
  end
end
