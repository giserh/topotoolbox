function GRIDobj2ascii(DEM,filename,type)

% write/export GRIDobj to ESRI ArcGIS ASCII file
% 
% Syntax
%     
%     GRIDobj2ascii(DEM)
%     GRIDobj2ascii(DEM,filename)
%
% Description
%
%     GRIDobj2ascii writes a matrix to an ESRI ArcGIS ASCII file. 
%     filename must be a string indicating the relative or absolute 
%     file path. The extension must be either .txt or .asc. With only one
%     input argument, GRIDobj2ascii will open a dialog box to save the
%     file.
%
% 
% Author: Wolfgang Schwanghart (w.schwanghart[at]unibas.ch)
% Date: 15. March, 2009

narginchk(1,3)

allowedExtensions = {'.txt','.asc'};
[X,Y] = refmat2XY(DEM.refmat,DEM.size);

if nargin == 1;    
    
    [FileName,PathName] = uiputfile({'*.txt';'*.asc'});
    if FileName == 0
        disp('     no output written to disk')
        return
    end
    filename = [PathName FileName];
    
    
elseif nargin == 2
    [~,~,ext] = fileparts(filename);    
    if any(strcmpi(ext,allowedExtensions));

    else
        error('File extension ambiguous.')
    end
else
    type = validatestring(type,allowedExtensions);
    filename = [filename type];
end    



siz = DEM.size;
cellsize = Y(1)-Y(2);
nodata   = -9999;

% write header
fid = fopen(filename,'w');
fprintf(fid,'ncols         %g\n',siz(2));
fprintf(fid,'nrows         %g\n',siz(1));
fprintf(fid,'xllcorner     %f\n',min(X(1,:))-abs(cellsize/2));
fprintf(fid,'yllcorner     %f\n',min(Y(:,1))-abs(cellsize/2));
fprintf(fid,'cellsize      %g\n',abs(cellsize));
fprintf(fid,'NODATA_value  %g\n',nodata);
fclose(fid);

DEM.Z(isnan(DEM.Z)) = nodata;

if cellsize<0;
    DEM.Z        = flipud(DEM.Z);
end

dlmwrite(filename,DEM.Z,'-append', 'delimiter',' ');



    