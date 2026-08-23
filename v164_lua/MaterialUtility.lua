MaterialUtility = {}
MaterialUtility.grey = nil
MaterialUtility.diffuse = nil

function MaterialUtility:GetGreyMat()
  if MaterialUtility.grey == nil then
    local greyshader = CS.UnityEngine.Shader.Find("FGQJ/UI/Grey")
    if greyshader ~= nil then
      MaterialUtility.grey = CS.UnityEngine.Material(greyshader)
    end
  end
  return MaterialUtility.grey
end

function MaterialUtility:GetDiffuseUnLitMat()
  if MaterialUtility.diffuse == nil then
    local diffuseShader = CS.UnityEngine.Shader.Find("FGQJ/UI/Transparent Colored")
    if diffuseShader ~= nil then
      MaterialUtility.diffuse = CS.UnityEngine.Material(diffuseShader)
    end
  end
  return MaterialUtility.diffuse
end
