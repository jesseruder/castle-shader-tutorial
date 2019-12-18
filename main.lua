local ui = castle.ui

local shaderString = [[vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor = Texel(tex, texture_coords);
    return texturecolor * color;
}]]
local shader = nil
local time = 0.0
local sendTimeUniform = false
local sendTimeUniformValueAtCompileTime = false

function love.load()
  image = love.graphics.newImage('castle.png')
end

function castle.uiupdate()
  shaderString = ui.textArea('Shader', shaderString, {
    rows = 16,
  })

  sendTimeUniform = ui.checkbox('Send "time" uniform', sendTimeUniform)

  local clicked = ui.button('Update')

  if clicked or shader == nil then
    shader = love.graphics.newShader(shaderString)

    time = 0.0
    sendTimeUniformValueAtCompileTime = sendTimeUniform
  end
end

function love.draw()
  if shader then
    if sendTimeUniformValueAtCompileTime then
      shader:send('time', time)
    end

    love.graphics.setShader(shader)
    love.graphics.draw(image, 0, 0)
    love.graphics.setShader()
  end
end

function love.update(dt)
  time = time + dt
end
