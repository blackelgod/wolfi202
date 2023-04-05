class User < ApplicationRecord
  def self.find_or_create_from_auth_hash(auth)
		where(uid: auth.uid).first_or_initialize.tap do |user|
			user.uid = auth.uid
			user.email = auth.info.email
      user.username = auth.extra.raw_info.username
      user.discriminator = auth.extra.raw_info.discriminator
      user.avatar = auth.extra.raw_info.avatar
      user.save!
		end
	end
end
