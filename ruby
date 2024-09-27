class User
  attr_accessor :name, :email, :password, :rooms

  def initialize(name, email, password)
    @name = name
    @email = email
    @password = password
    @rooms = []
  end

  def enter_room(room)
    return if @rooms.include?(room)

    @rooms << room
    room.add_user(self)
  end

  def send_message(room, content)
    return unless @rooms.include?(room)

    message = Message.new(self, room, content)
    room.broadcast(message)
  end

  def acknowledge_message(room, message)
    return unless @rooms.include?(room)

    puts "#{@name} acknowledged message: #{message.content}"
  end
end

class Room
  attr_accessor :name, :description, :users

  def initialize(name, description)
    @name = name
    @description = description
    @users = []
  end

  def add_user(user)
    @users << user unless @users.include?(user)
  end

  def broadcast(message)
    @users.each do |user|
      puts "#{user.name} received message in #{@name}: #{message.content}"
    end
  end
end

class Message
  attr_accessor :user, :room, :content

  def initialize(user, room, content)
    @user = user
    @room = room
    @content = content
  end
end

# Example usage
if __FILE__ == $0
  user1 = User.new("Yok", "yok@gmail.com", "pass123")
  user2 = User.new("Pailin", "pailin@gmail.com", "pass456")

  room = Room.new("Chat Room 1", "A place for general chat")

  user1.enter_room(room)
  user2.enter_room(room)

  user1.send_message(room, "Hello, everyone!")
  user2.send_message(room, "Hi Yok")

  user1.acknowledge_message(room, Message.new(user2, room, "Hi Yok"))
end
