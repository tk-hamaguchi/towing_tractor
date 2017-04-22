class CreateTowingTractorDockerServers < ActiveRecord::Migration[5.1]
  def change
    create_table :towing_tractor_docker_servers do |t|
      t.string :name
      t.string :url
      t.timestamp :keepalived_at
      t.text :ca_cert
      t.text :client_cert
      t.text :client_key

      t.timestamps
    end
  end
end
