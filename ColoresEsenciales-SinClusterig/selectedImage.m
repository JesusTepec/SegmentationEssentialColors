function im = selectedImage()
%%
%Selected a image
%get the file of a image
%return image
%
Filter={'*.jpg;*.jpeg;*.png;*.tiff'};
[FileName, FilePath]=uigetfile(Filter);
pause(0.01);
if FileName == 0
    return;
end
FullFileName=[FilePath FileName];
im = imread(strcat(FullFileName));