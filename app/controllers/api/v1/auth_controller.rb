class Api::V1::AuthController < ApplicationController
  before_action :authenticate_request, only: [:me]

  def login
    result = Auth::Operation::Login.call(params: login_params)
    
    if result.success?
      user_data = Auth::Representer::User.new(result[:user]).to_hash
      
      render json: {
        success: true,
        data: {
          user: user_data,
          accessToken: result[:access_token],
          refreshToken: result[:refresh_token]
        },
        message: "Login exitoso"
      }, status: :ok
    else
      render json: {
        success: false,
        errors: result[:errors] || result[:contract].errors.as_json,
        message: "Error en el login"
      }, status: :unprocessable_entity
    end
  end

  def register
    result = Auth::Operation::Register.call(params: register_params)
    
    if result.success?
      user_data = Auth::Representer::User.new(result[:user]).to_hash
      
      render json: {
        success: true,
        data: {
          user: user_data,
          accessToken: result[:access_token],
          refreshToken: result[:refresh_token]
        },
        message: "Registro exitoso"
      }, status: :created
    else
      render json: {
        success: false,
        errors: result[:errors] || result[:contract].errors.as_json,
        message: "Error en el registro"
      }, status: :unprocessable_entity
    end
  end

  def forgot_password
    result = Auth::Operation::ForgotPassword.call(params: forgot_password_params)
    
    if result.success?
      render json: {
        success: true,
        message: "Correo de recuperación enviado exitosamente"
      }, status: :ok
    else
      render json: {
        success: false,
        errors: result[:errors] || result[:contract].errors.as_json,
        message: "Error al procesar la solicitud"
      }, status: :unprocessable_entity
    end
  end

  def validate_reset_token
    result = Auth::Operation::ValidateResetToken.call(params: validate_token_params)
    
    if result.success?
      render json: {
        success: true,
        message: "Token válido"
      }, status: :ok
    else
      render json: {
        success: false,
        errors: result[:errors] || result[:contract].errors.as_json,
        message: "Token inválido o expirado"
      }, status: :unprocessable_entity
    end
  end

  def reset_password
    result = Auth::Operation::ResetPassword.call(params: reset_password_params)
    
    if result.success?
      render json: {
        success: true,
        message: "Contraseña restablecida exitosamente"
      }, status: :ok
    else
      render json: {
        success: false,
        errors: result[:errors] || result[:contract].errors.as_json,
        message: "Error al restablecer la contraseña"
      }, status: :unprocessable_entity
    end
  end

  def me
    result = Auth::Operation::Me.call(current_user: @current_user)
    
    if result.success?
      user_data = Auth::Representer::User.new(result[:user]).to_hash
      
      render json: {
        success: true,
        data: user_data
      }, status: :ok
    else
      render json: {
        success: false,
        errors: result[:errors],
        message: "Usuario no autenticado"
      }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def register_params
    params.permit(:name, :email, :password, :confirm_password, :confirmPassword, :phone, :role)
  end

  def forgot_password_params
    params.permit(:email)
  end

  def validate_token_params
    params.permit(:token)
  end

  def reset_password_params
    params.permit(:token, :password)
  end

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    if header
      @current_user = JwtService.verify_token(header, 'access')
      unless @current_user
        render json: { 
          success: false, 
          message: 'Token inválido o expirado' 
        }, status: :unauthorized
      end
    else
      render json: { 
        success: false, 
        message: 'Token de autorización requerido' 
      }, status: :unauthorized
    end
  end
end
