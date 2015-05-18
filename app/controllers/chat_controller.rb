class ChatController < ApplicationController
  include Tubesock::Hijack
  require 'gameclasses'


  ##Chat
  #In charge of all chat display
  def chat
    hijack do |tubesock|
      redis_thread = Thread.new do
        Redis.new.subscribe "chat" do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        boardAaux = GlobalConstants::BOARDA
        boardBaux = GlobalConstants::BOARDB
       
        SendEvents.EventDispatch(m.split(","))

        boardAauxRenglon = []
        boardBauxRenglon =[]
        if(current_user.name != nil)
          Redis.new.publish "chat", "#{boardAaux.getName}'s BOARD * --- * --- * --- * --- * --- * --- * --- * #{boardBaux.getName}'s BOARD"

          if(current_user.name.to_s == boardAaux.getName)
             boardAauxRenglon = boardAaux.printAll
              boardBauxRenglon = GlobalConstants::BOARDAAUX.printAll
            Redis.new.publish "chat", "#{boardAauxRenglon[0]} * --- * --- * --- * #{boardBauxRenglon[0]}"
            for i in 1..10
              Redis.new.publish "chat", "#{boardAauxRenglon[i]}  * --- * --- * --- * --- * #{boardBauxRenglon[i]}"
            end
          else
            boardAauxRenglon = GlobalConstants::BOARDBAUX.printAll
            boardBauxRenglon = boardBaux.printAll
              Redis.new.publish "chat", "#{boardAauxRenglon[0]} * --- * --- * --- * #{boardBauxRenglon[0]}"
            for i in 1..10
              Redis.new.publish "chat", "#{boardAauxRenglon[i]}  * --- * --- * --- * --- * #{boardBauxRenglon[i]}"
            end
          end
        end
      end
      
      tubesock.onclose do
        # stop listening when client leaves
        redis_thread.kill
      end
    end


  end
  
end
