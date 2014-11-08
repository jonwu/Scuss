# Renjie Long
# Bryant Chang
# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Channel < ActiveRecord::Base
  has_many :messages
  has_many :user_channels
  has_many :users, through: :user_channel
  validates :api_id, presence: true
  validates :api_id, uniqueness: true
  validates :name, presence: true

  def self.get_messages(id)
    h = []
    Message.where(channel_id: id).each do |c|
      h+= [{user: c.user.username, body: c.body}]
    end
    return h
  end

  def get_users
    self.users.all
  end

  def check_in(uid)
    #TODO: Check if user is in it first
    self.user_channels.create(user_id: uid, timeout: DateTime.in(120))
  end

  def cleanup_users
    #TODO: REMOVE INACTIVE USERS
  end

  # extract values from detail json
  def self.parse_detail(show)
    overview = show['overview']
    homepage = show['homepage']
    name = show['name']
    networks = show['networks']
    poster_path = show['poster_path']
    id = show['id']
    new_json = {
      id:id,  
      overview: overview,
      homepage: homepage,
      name: name,
      poster_path: poster_path,
      network: nil,
    }
    
    if networks.size > 0
      network_name = networks[0]['name']
      p network_name
      new_json[:network] = network_name
    end
    
    return new_json
  end

  def self.follow(params, current_user)
    if params.has_key?(:cid)
      if !current_user.favorites.exists?(:channel_id => params[:cid])
        current_user.favorites.create(:channel_id => params[:cid])
      end
    elsif params.has_key?(:api_id)

      if Channel.find_by(api_id: params[:api_id]) == nil
        Channel.create(channel_params)
      end
      # p Channel.find_by api_id: params[:api_id]
      cid = (Channel.find_by api_id: params[:api_id]).id
      if !current_user.favorites.exists?(:channel_id => cid)
        current_user.favorites.create(:channel_id => cid)
      end
    end
  end

  def self.unfollow(params, current_user)
    cid = nil
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key?(:api_id)
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
    if current_user.favorites.exists?(:channel_id => cid)
      to_delete = Favorite.where(:channel_id => cid, :user_id => current_user.id)[0]
      Favorite.destroy(to_delete.id)
    end
  end

  def self.following(params, current_user)
    following = false
    if params.has_key?(:id) and (Channel.find_by api_id: params[:id]) != nil and current_user != nil
      id = (Channel.find_by api_id: params[:id]).id
      following = Favorite.find_by(channel_id: id, user_id: current_user.id) !=nil
    end
    return following
  end

  def self.active_delete(params, current_user)
    cid = nil
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key?(:api_id) and Channel.find_by(api_id: params[:api_id]) != nil
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
    if current_user.actives.exists?(:channel_id => cid)
      to_delete = Active.where(:channel_id => cid, :user_id => current_user.id)[0]
      Active.destroy(to_delete.id)
    end
  end

  def self.active_update(params, current_user)
    cid = nil
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key?(:api_id) and Channel.find_by(api_id: params[:api_id]) != nil
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
      
    if cid != nil and current_user.actives.exists?(:channel_id => cid)
      entry = Active.where(:channel_id => cid)[0]
      entry.updated = DateTime.now
      entry.save()
    elsif cid != nil
      self.active_add(params, current_user)
    end
  end

  def self.active_add(params, current_user)
    cid = nil
    if params.has_key?(:cid)
      cid = params[:cid]
    elsif params.has_key?(:api_id) and Channel.find_by(api_id: params[:api_id]) != nil
      cid = (Channel.find_by api_id: params[:api_id]).id
    end
      
    if cid != nil and !current_user.actives.exists?(:channel_id => cid)
      current_user.actives.create(:channel_id => cid, :updated => DateTime.now)
    end
  end

  def self.active_user_list(params, current_user)
    l = []
    # p params
    timenow = DateTime.now
    cid = params[:id]
    if cid != nil and Active.exists?(:channel_id => cid)
      l = Active.where(:channel_id => cid).where("updated > ?", timenow-20.seconds)
    end
    userlist = []
    for entry in l
      # p "ENTRY"*100
      # p entry
      eid = entry.user_id
      username = User.where(:id => eid)[0].username
      # entry["username"] = username
      userlist += [username]
    end
    return userlist
  end
end
