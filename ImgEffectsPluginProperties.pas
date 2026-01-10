{
    Copyright (C) 2026 VCC
    creation date: 09 Jan 2026
    initial release date: 09 Jan 2026

    author: VCC
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


unit ImgEffectsPluginProperties;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ClickerUtils, ClickerActionPlugins;


type
  TImageEffect = (ieBlur4x, ieBlur8x, ieBlur_Reserved, ieGrayscale);
  TBackgroundFileLocation = (bflDisk, bflMem, bflDiskToMem);

const
  CPropertiesCount = 6;

  CImageEffectPropertyIndex = 0;
  CTakeScreenshotForBackgroundPropertyIndex = 1;
  CScreenshotSettingsActionPropertyIndex = 2;
  CBackgroundFileNamePropertyIndex = 3;
  CBackgroundFileLocationPropertyIndex = 4;
  COtherBitmapsActionPropertyIndex = 5;

  CImageEffectPropertyName = 'ImageEffect';
  CTakeScreenshotForBackgroundPropertyName = 'TakeScreenshotForBackground';
  CScreenshotSettingsActionPropertyName = 'ScreenshotSettingsAction';
  CBackgroundFileNamePropertyName = 'BackgroundFileName';
  CBackgroundFileLocationPropertyName = 'BackgroundFileLocation';
  COtherBitmapsActionPropertyName = 'OtherBitmapsAction';

  CImageEffect_ieBlur4x = 'ieBlur4x';
  CImageEffect_ieBlur8x = 'ieBlur8x';
  CImageEffect_ieBlur_Reserved = 'ieBlur_Reserved'; //other blur algorithm (reserved for now)
  CImageEffect_ieGrayscale = 'ieGrayscale';  //may include interlace lines as an option

  CImageEffectStr: array[TImageEffect] of string = (CImageEffect_ieBlur4x, CImageEffect_ieBlur8x, CImageEffect_ieBlur_Reserved, CImageEffect_ieGrayscale);
  CEffectStr = '_effect';

  CBackgroundFileLocation_bflDisk = 'bflDisk';
  CBackgroundFileLocation_bflMem = 'bflMem';
  CBackgroundFileLocationbflDiskToMem = 'bflDiskToMem';

  CBackgroundFileLocationStr: array[TBackgroundFileLocation] of string = (CBackgroundFileLocation_bflDisk, CBackgroundFileLocation_bflMem, CBackgroundFileLocationbflDiskToMem);


  CRequiredPropertyNames: array[0..CPropertiesCount - 1] of string = (  //these are the expected property names, configured in plugin properties
    CImageEffectPropertyName,
    CTakeScreenshotForBackgroundPropertyName,
    CScreenshotSettingsActionPropertyName,
    CBackgroundFileNamePropertyName,
    CBackgroundFileLocationPropertyName,
    COtherBitmapsActionPropertyName
  );

  //property details: (e.g. enum options, hints, icons, menus, min..max spin intervals etc)

  //See TOIEditorType datatype from ObjectInspectorFrame.pas, for valid values
  CRequiredPropertyTypes: array[0..CPropertiesCount - 1] of string = (
    'EnumCombo', //ImageEffect
    'BooleanCombo', //TakeScreenshotForBackground
    'TextWithArrow', //ScreenshotSettingsAction
    'TextWithArrow', //BackgroundFileName
    'EnumCombo', //BackgroundFileLocation
    'TextWithArrow' //OtherBitmaps
  );

  CRequiredPropertyDataTypes: array[0..CPropertiesCount - 1] of string = (
    CDTEnum, //ImageEffect
    CDTBool, //TakeScreenshotForBackground
    CDTString, //ScreenshotSettingsAction
    CDTString, //BackgroundFileName
    CDTEnum, //BackgroundFileLocation
    CDTString //OtherBitmaps
  );

  CPluginEnumCounts: array[0..CPropertiesCount - 1] of Integer = (
    4, //ImageEffect
    0, //TakeScreenshotForBackground
    0, //ScreenshotSettingsAction
    0, //BackgroundFileName
    3, //BackgroundFileLocation
    0  //OtherBitmaps
  );

  CPluginEnumStrings: array[0..CPropertiesCount - 1] of string = (
    CImageEffect_ieBlur4x + #4#5 + CImageEffect_ieBlur8x + #4#5 + CImageEffect_ieBlur_Reserved + #4#5 + CImageEffect_ieGrayscale, //ImageEffect
    '', //TakeScreenshotForBackground
    '', //ScreenshotSettingsAction
    '', //BackgroundFileName
    CBackgroundFileLocation_bflDisk + #4#5 + CBackgroundFileLocation_bflMem + #4#5 + CBackgroundFileLocationbflDiskToMem, //BackgroundFileLocation
    ''  //OtherBitmaps
  );

  CPluginHints: array[0..CPropertiesCount - 1] of string = (
    'The image effect to be applied to a background bitmap (e.g. a screenshot) and other configured bitmaps.', //ImageEffect
    'If True, the plugin takes a screenshot, using the setting from the action, mentioned in the ' + CScreenshotSettingsActionPropertyName + ' property.', //TakeScreenshotForBackground
    'Name of an existing FindSubControl action, which is used to get the screenshot settings.' + #4#5 + 'Usually, a FindControl action may have to be executed prior to this action, to prepare the control and the screenshot area.' + #4#5 + 'The screenshot is saved to ExtRendering InMem file system, using the ' + CScreenshotFilename + ' name.' + #4#5 + 'This may have to be a disabled action, so it won''t be executed automatically.',  //ScreenshotSettingsAction
    'Name of a bitmap file, used as a background bitmap (the one where the text or other bitmaps are searched on), which will be used as a source bitmap for applying the selected effect.' + #4#5 + 'The destination file name is derived from this name, by applying the "' + CEffectStr + '" suffix, before the file extension.' + #4#5 + 'This property can be left empty, to apply no effect to a background bitmap.',  //BackgroundFileName
    'Location of the background bitmap file:' + #4#5 + '  ' + CBackgroundFileLocation_bflDisk + ' - Loads the file from disk and saves the converted file to disk.' + #4#5 + '  ' + CBackgroundFileLocation_bflMem + ' - Loads the file from Ext InMem FS and saves the converted file to Ext InMem FS.' + #4#5 + '  ' + CBackgroundFileLocationbflDiskToMem + ' - Loads the file from disk and saves the converted file to Ext InMem FS.', //BackgroundFileLocation
    'Name of an existing FindSubControl action, which is used to get the file names of the searched bitmaps.' + #4#5 + 'These can be bitmap files, from the MatchBitmapFiles property, or the bitmap files generated from text, when the action is configured to only render text (its MatchBitmapAlgorithm is set to mbaRenderTextOnly).' + #4#5 + 'In case of a render text only action, the bitmap files are loaded from the ExtRendering InMem file system. They have the "ExtMem:\<ActionName>_<ProfileName>.bmp" format.' + #4#5 + 'In the same way as applying the effect on the background bitmap, the destination files will have the "' + CEffectStr + '" suffix.' + #4#5 + 'This property can be left empty, to apply no effect on other bitmap files.' //OtherBitmaps
  );

  CPropertyEnabled: array[0..CPropertiesCount - 1] of string = (  // The 'PropertyValue[<index>]' replacement uses indexes from the following array only. It doesn't count fixed properties.
    '', //ImageEffect                        // If empty string, the property is unconditionally enabled. For available operators, see CComp constans in ClickerUtils.pas.
    '', //TakeScreenshotForBackground
    'PropertyValue[1]==True', //ScreenshotSettingsAction
    '', //BackgroundFileName
    '', //BackgroundFileLocation
    '' //OtherBitmaps
  );

  CPluginDefaultValues: array[0..CPropertiesCount - 1] of string = (
    CImageEffect_ieBlur4x, //ImageEffect
    'True', //TakeScreenshotForBackground
    '', //ScreenshotSettingsAction
    CScreenshotFilename, //BackgroundFileName
    CBackgroundFileLocation_bflMem,
    ''  //OtherBitmaps
  );


function FillInPropertyDetails: string;


implementation


function FillInPropertyDetails: string;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to CPropertiesCount - 1 do
    Result := Result + CRequiredPropertyNames[i] + '=' + CRequiredPropertyTypes[i] + #8#7 +
                       CPluginPropertyAttr_DataType + '=' + CRequiredPropertyDataTypes[i] + #8#7 +
                       CPluginPropertyAttr_EnumCounts + '=' + IntToStr(CPluginEnumCounts[i]) + #8#7 +
                       CPluginPropertyAttr_EnumStrings + '=' + CPluginEnumStrings[i] + #8#7 +
                       CPluginPropertyAttr_Hint + '=' + CPluginHints[i] + #8#7 +
                       CPluginPropertyAttr_Enabled + '=' + CPropertyEnabled[i] + #8#7 +
                       CPluginPropertyAttr_DefaultValue + '=' + CPluginDefaultValues[i] + #8#7 +
                       #13#10;
end;

end.

