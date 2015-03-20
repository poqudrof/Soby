class Cam 

  include_package 'processing.core'

#  java_import 'toxi.geom.Matrix4x4'

  attr_accessor :mat, :angle, :translation, :scale, :pre_translation, :post_translation
  attr_accessor :quat 

  @@interp = Processing::PMatrix3D.new

  def initialize 
    @scale = 1
    @angle = 0;
    @translation = PVector.new
    @mat = PMatrix3D.new
    @pre_translation = PVector.new
    @post_translation = PVector.new

    @is_computed = false
  end 

  ## TODO: check modif at
  def compute_mat

    puts "Warning Camera already computed " if @is_computed
    return if @is_computed

    @is_computed = true

    @mat.reset

    @mat.translate(@post_translation.x, @post_translation.y)
    @mat.scale(@scale)

    @mat.translate(@translation.x, @translation.y)
    @mat.rotate(@angle)

    @mat.translate(@pre_translation.x, @pre_translation.y)

    @mat
  end



  # Value = 0 :  self,   value  = 1  : cam2
  def lerp(cam2, value) 

    complement = 1 - value

    # puts "Value #{value} "
    # puts "complement #{complement} "

    interp = @@interp
    interp.reset

    interp.m00 = @mat.m00 * complement + cam2.mat.m00 * value
    interp.m01 = @mat.m01 * complement + cam2.mat.m01 * value
    interp.m02 = @mat.m02 * complement + cam2.mat.m02 * value
    interp.m03 = @mat.m03 * complement + cam2.mat.m03 * value

    interp.m10 = @mat.m10 * complement + cam2.mat.m10 * value
    interp.m11 = @mat.m11 * complement + cam2.mat.m11 * value
    interp.m12 = @mat.m12 * complement + cam2.mat.m12 * value
    interp.m13 = @mat.m13 * complement + cam2.mat.m13 * value
    
    interp.m20 = @mat.m20 * complement + cam2.mat.m20 * value
    interp.m21 = @mat.m21 * complement + cam2.mat.m21 * value
    interp.m22 = @mat.m22 * complement + cam2.mat.m22 * value
    interp.m23 = @mat.m23 * complement + cam2.mat.m23 * value
    
    interp.m30 = @mat.m30 * complement + cam2.mat.m30 * value
    interp.m31 = @mat.m31 * complement + cam2.mat.m31 * value
    interp.m32 = @mat.m32 * complement + cam2.mat.m32 * value
    interp.m33 = @mat.m33 * complement + cam2.mat.m33 * value

    interp

  end

  private
  
  def create_mat4x4(mat) 
    Matrix4x4.new(mat.m00, mat.m01, mat.m02, mat.m03,\
                  mat.m10, mat.m11, mat.m12, mat.m13,\
                  mat.m20, mat.m21, mat.m22, mat.m23,\
                  mat.m30, mat.m31, mat.m32, mat.m33)
  end

  def create_pmatrix(mat) 
    PMatrix3D.new(mat[0][0], mat[0][1], mat[0][2], mat[0][3],\
                  mat[1][0], mat[1][1], mat[1][2], mat[1][3],\
                  mat[2][0], mat[2][1], mat[2][2], mat[2][3],\
                  mat[3][0], mat[3][1], mat[3][2], mat[3][3])
  end

  def set_pmatrix(mat, pmatrix)
    pmatrix.set(mat[0][0], mat[0][1], mat[0][2], mat[0][3],\
                mat[1][0], mat[1][1], mat[1][2], mat[1][3],\
                mat[2][0], mat[2][1], mat[2][2], mat[2][3],\
                mat[3][0], mat[3][1], mat[3][2], mat[3][3])
  end
end 
