class User < ActiveRecord::Base
	has_secure_password
	has_many :statuses
	has_many :mentions
	#has_many :unread_mentions, -> (){where('viewed_at is NULL')}, class_name: 'Mention', foreign_key: 'user_id'

	#must specify associations within the join model b/c you're working on both side of the model(User)
	has_many :follower_relationships, class_name: "Relationship", foreign_key: "leader_id"
	has_many :leader_relationships, class_name: "Relationship", foreign_key: "follower_id"
	#users that are following me
	has_many :follower_users, through: :follower_relationships, source: :follower
	#users that I follow
	has_many :following_users, through: :leader_relationships, source: :leader

	validates :username, presence: true
	validates :email, presence: true

	def num_unread_mentions
		mentions.where(viewed_at: nil).count
	end

	def unread_mentions
		mentions.where(viewed_at: nil)
	end

	def mark_unread_mentions!
		unread_mentions.each do |mention|
			mention.mark_viewed!
		end
	end



end
