
 d=dir('*.tif');
  for i=1:length(d)
      %Reads in .dat file
      fname = d(i).name;
      fname_new = fname(1:end-4);
      fname_R = [fname_new, '_R.tiff'];
      fname_G = [fname_new, '_G.tiff'];
      raw_img = imread(fname);
      [R,G,B] = imsplit(raw_img);
      %Converts to TIFF and gives it the .tiff extension
      fname = [fname(1:end-4),'.tiff'];
      imwrite(R,fname_R,'tiff');
      imwrite(G,fname_G,'tiff');

  end