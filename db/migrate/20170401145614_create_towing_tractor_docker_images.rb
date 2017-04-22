class CreateTowingTractorDockerImages < ActiveRecord::Migration[5.1]
  def change
    create_table :towing_tractor_docker_images do |t|
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
