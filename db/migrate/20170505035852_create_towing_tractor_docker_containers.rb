class CreateTowingTractorDockerContainers < ActiveRecord::Migration[5.1]
  def change
    create_table :towing_tractor_docker_containers do |t|
      t.integer :image_id
      t.integer :server_id
      t.string :container_id
      t.text :env
      t.text :cmd
      t.timestamp :last_keepalived_at

      t.timestamps
    end
  end
end
