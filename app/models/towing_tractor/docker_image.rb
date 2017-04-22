module TowingTractor
  class DockerImage < ApplicationRecord
    validates :name,
      presence: true

    validates :image,
      uniqueness: true,
      presence: true
  end
end
