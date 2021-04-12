class PaymentController < ApplicationController

  # FUNCTION TO CALL TO GENERATE ACCESS-TOKEN
  def get_token_vanilla_pay
    query = HTTParty.get("https://pro.ariarynet.com/oauth/v2/token?client_id=#{ ENV["VANILLA_PAY_CLIENT_ID"] }&client_secret=#{ ENV["VANILLA_PAY_CLIENT_SECRET"] }&grant_type=client_credentials")
    render json: query.parsed_response
  end

  # FUNCTION TO CALL WHEN TO INIT PAYMENT
  def init_vanilla_pay
    vanilla_params = {
      unitemonetaire: "Ar",
      adresseip: params[:adresseip],
      idpanier: params[:ticket_id],
      montant: params[:amount],
      nom: params[:name],
      email: params[:email],
      reference: params[:reference]
    }

    params_des = encrypt(ENV['VANILLA_PAY_PUBLIC_KEY'], vanilla_params.to_json)
    query = HTTParty.post("https://pro.ariarynet.com/api/paiements",
      headers: {
        "Authorization": "Bearer " + params[:access_token]
      },
      body: {
        site_url: params[:site_url],
        params: bin_to_hex(params_des),
        unitemonetaire:"Ar",
        adresseip:params[:adresseip],
        idpanier: params[:ticket_id],
        montant: params[:amount],
        nom: params[:name],
        email: params[:email],
        reference: params[:reference]
      }
    )

    vanilla_pay_id = decrypt(ENV['VANILLA_PAY_PRIVATE_KEY'], hex_to_bin(query.to_s))


    render json: { vanilla_pay_url: "https://moncompte.ariarynet.com/payer/#{vanilla_pay_id}" }
  end

  # FUNCTION TO CALL FOR VANMILLA PAY NOTIFICATION
  def webhook_for_vanilla_pay_notification
    # DO SOMETHING
  end

  protected

    # FUNCTION TO CONVERT STRING TO HEX
    def bin_to_hex(s)
      s.each_byte.map { |b| b.to_s(16) }.join
    end
    
    # FUNCTION TO CONVERT HEX TO STRING
    def hex_to_bin(s)
      s.scan(/../).map { |x| x.hex }.pack('c*')
    end

    # FUNCTION TO DECRYPT STRING IN DES3 IN ECB MODE
    def decrypt(key, data)
      # Effectively the same as the `encrypt` method
      cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3')
      cipher.decrypt # Also must be called before anything else
    
      cipher.key = key
    
      output = cipher.update(data)
      output << cipher.final
      output
    end
    
    # FUNCTION TO ENCRYPT STRING IN DES3 IN ECB MODE
    def encrypt(key, data)
      cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3')
      cipher.encrypt # Must be called before anything else
    
      cipher.key = key
    
      output = cipher.update(data)
      output << cipher.final
      output
    end

end
