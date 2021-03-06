module UsersHelper

  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=200"
  end
end
