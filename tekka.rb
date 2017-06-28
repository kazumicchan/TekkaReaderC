require 'net/https'
require 'pp'
require 'Kconv'
require 'json'

class Access
	def login
		mail     = ''
		password = ''

		https = Net::HTTP.new('tekka.pw', 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = https.start{|https|
		    https.post('/api/v1/auth/login/client', "login_id=#{mail}&login_pwd=#{password}")
		}
		@cookie = response['Set-Cookie'].split(',').join(';')
		puts "Login OK"
		response = https.get("/api/v1/sns/status/all", 'Cookie' => @cookie)
		message= response.body
		hash2= JSON.parse(message)
		@msg_max=hash2["result"]["msg_max"]
		@reply_max=hash2["result"]["reply_max"]	
		
        response = https.get("/api/v1/sns/status/info?last_msg_max=#{@msg_max-15}&last_reply_max=#{@reply_max}", 'Cookie' => @cookie)
		message= response.body
		@hash2= JSON.parse(message)
		@reply_max=@hash2["result"]["reply_max"]
		@membfs=@hash2["result"]["channel_msgs"]["tesso"]["chitchat"].length
				for i in 0..@membfs-1
				puts @hash2["result"]["channel_msgs"]["tesso"]["chitchat"][i]["nickname"]
				puts @hash2["result"]["channel_msgs"]["tesso"]["chitchat"][i]["text"]
				end


	end
	def leading(num)
		https = Net::HTTP.new('tekka.pw', 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = https.get("/api/v1/sns/status/info?last_msg_max=#{@msg_max-15}&last_reply_max=#{@reply_max}", 'Cookie' => @cookie)
		message= response.body
		@hash2= JSON.parse(message)
		@memb=@hash2["result"]["channel_msgs"]["tesso"]["chitchat"].length
		null =@hash2["result"]["channel_msgs"]["tesso"].nil?
		if null != true
			msgno=@hash2["result"]["channel_msgs"]["tesso"]["chitchat"][@memb-1]["msgno"]

			if msgno != $msgno2
			

				for i in @membfs..@memb-1
				puts @hash2["result"]["channel_msgs"]["tesso"]["chitchat"][i]["nickname"]
				puts @hash2["result"]["channel_msgs"]["tesso"]["chitchat"][i]["text"]
				end
			end
			@membfs=@memb
			$msgno2 = msgno
		end
	end
end
access = Access.new
access.login
num =0
$msgno2=0

while true
access.leading(num)
sleep (10)
end

