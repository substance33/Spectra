function rescal(option)
%
% RESCAL version 1.0
%
% MATLAB function to calculate the resolution function, Bragg widths, phonon widths &c of
% a triple axis neutron spectrometer. Either the Cooper-Nathan's or Popovici's method
% may be selected. If called with no parameters, then the resolution function
% and simulation of scans may be performed. If called with option = 'trixmode', 
% then the windows are configured for fitting using the trix function in mfit.
%
% Call to:
%
%
% Summary of main tag handles:
%
%    Rescal: Parameters     - Main rescal window
%
%    hrc_paras              - Edit boxes of rescal parameters
%    hrc_text               - Text boxes of rescal parameters
%    htrix_scan             - Edit boxes of scan parameters in trix mode
%    hrc_units_paras	    - Units 
%    hrc_units_current      - Settings of units previous to any change
%
%    hrc_rescal_method      - Method menu
%    hrc_rescal_rescal      - Rescal menu
%    hrc_rescal_simulation  - Simulation menu
%
% Data file defaults:
%
%    rescal.par             - Standard rescal parameters common to Cooper-Nathan's and Popovici methods
%    rescal.cfg             - Instrument parameters used by Popovici only
%    rescal.sim             - Parameters for simulation mode
%    rescal.scn             - Scan parameters for trix mode
%
% D.A.T. & D.F.M. 1996
%
% Updated to allow energies to be entered as Angs-1 or meV.
% 10.Apr.98 D.A.T.
% -----------------------------------------------------------------------------

%----- Set default fonts 

set(0,'DefaultAxesFontName','times')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultTextFontName','times')
set(0,'DefaultTextFontSize',14)


if nargin==0

  option='initialise';


end

% disp(['Rescal option ' option ' chosen']);

if (strcmp(option,'initialise')|strcmp(option,'trixmode'))

%----- Check to see if Rescal is already running, and restart if it is

if ~isempty(findobj('Tag','Rescal: Parameters'))

   rc_exit;

end

%----- Create control window 

Fposl=100; Fposb=100; Fwidth=460; Fheight=500;

rc_params=figure('Position',[Fposl Fposb Fwidth Fheight],...
		'NextPlot','New',...
		'Color',get(0,'DefaultUicontrolBackgroundColor'), ...
		'MenuBar','none',...
		'Name','Rescal: Parameters',...
		'NumberTitle','off',...
		'Resize','off',...
                'Tag','Rescal: Parameters', ...
		'DefaultUicontrolBackgroundColor',[1 1 1],...
		'DefaultUicontrolForegroundColor',[0 0 0],...
		'DefaultUicontrolHorizontalAlignment','left',...
		'Visible','on');

%----- Create text and edit windows

Tposl=10; Twidth=50; Theight=18; Tspacev=30; Tspaceh=110; Tposb= Fheight-50;
Eposl=Tposl+Twidth+5; Ewidth=50; Eheight=18; Espacev=30; Espaceh=110; Eposb=Fheight-50;
Delta=35;

%----- Frame for Spectrometer parameters

FrameX=5; FrameY=Fheight-210; FrameW=Fwidth-10; FrameH=205;
uicontrol(rc_params,...
	'Style','Frame',...
        'Position',[FrameX FrameY FrameW FrameH],...
        'BackgroundColor',[0 0 0])

uicontrol(rc_params,...
	'Style','Text',...
	'String','Spectrometer',...
        'Position',[Fwidth/8 Fheight-30 Fwidth*0.75 20],...
        'BackgroundColor',[0 0 0],...
        'ForegroundColor',[1 1 1],...
	'HorizontalAlignment','Center')

%----- Frame for Sample parameters

FrameX=5; FrameY=Fheight-365; FrameW=Fwidth-10; FrameH=145;
uicontrol(rc_params,...
	'Style','Frame',...
        'Position',[FrameX FrameY FrameW FrameH],...
        'BackgroundColor',[0 0 0])

uicontrol(rc_params,...
	'Style','Text',...
	'String','Lattice',...
        'Position',[Fwidth/8 FrameY+FrameH-24 Fwidth*0.75 20],...
        'BackgroundColor',[0 0 0],...
        'ForegroundColor',[1 1 1],...
	'HorizontalAlignment','Center')

%----- Frame for Scan parameters

FrameX=5; FrameY=Fheight-490; FrameW=Fwidth-10; FrameH=115;
uicontrol(rc_params,...
	'Style','Frame',...
        'Position',[FrameX FrameY FrameW FrameH],...
        'BackgroundColor',[0 0 0])

uicontrol(rc_params,...
	'Style','Text',...
	'String','Scan',...
        'Position',[Fwidth/8 FrameY+FrameH-24 Fwidth*0.75 20],...
        'BackgroundColor',[0 0 0],...
        'ForegroundColor',[1 1 1],...
	'HorizontalAlignment','Center')

%----- FWHM of DM and DA (units: minutes of arc)

hrc_text(1)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','DM', ...
     'Position',[Tposl Tposb Twidth Theight]);

hrc_text(2)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','DA', ...
     'Position',[Tposl+Tspaceh Tposb Twidth Theight]);

hrc_paras(1)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb Ewidth Eheight]);

hrc_paras(2)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb Ewidth Eheight]);

%----- FWHM of ETAM, ETAS, ETAA (units: minutes of arc)

hrc_text(3)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ETAM', ...
     'Position',[Tposl Tposb-Tspacev Twidth Theight]);

hrc_text(4)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ETAA', ...
     'Position',[Tposl+Tspaceh Tposb-Tspacev Twidth Theight]);

hrc_text(5)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ETAS', ...
     'Position',[Tposl+2*Tspaceh Tposb-Tspacev Twidth Theight]);

hrc_paras(3)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-Espacev Ewidth Eheight]);

hrc_paras(4)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-Espacev Ewidth Eheight]);

hrc_paras(5)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-Espacev Ewidth Eheight]);

%----- Sense of scattering SM, SS, SA

hrc_text(6)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','SM', ...
     'Position',[Tposl Tposb-2*Tspacev Twidth Theight]);

hrc_text(7)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','SS', ...
     'Position',[Tposl+Tspaceh Tposb-2*Tspacev Twidth Theight]);

hrc_text(8)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','SA', ...
     'Position',[Tposl+2*Tspaceh Tposb-2*Tspacev Twidth Theight]);

hrc_paras(6)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-2*Espacev Ewidth Eheight]);

hrc_paras(7)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-2*Espacev Ewidth Eheight]);

hrc_paras(8)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-2*Espacev Ewidth Eheight]);

%----- Wave vector KFIX, and flag for scan type (0 = KI fixed etc)

hrc_text(9)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','KFIX', ...
     'Position',[Tposl Tposb-3*Tspacev Twidth Theight]);

hrc_text(10)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','FX', ...
     'Position',[Tposl+Tspaceh Tposb-3*Tspacev Twidth Theight]);

hrc_paras(9)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-3*Espacev Ewidth Eheight]);

hrc_paras(10)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-3*Espacev Ewidth Eheight]);

% ----- choose units for Ki/Kf (1/Angs,meV,THz) ----------------------------

choices=str2mat('1/Angs','meV','THz');

hrc_units_paras(1)=uicontrol(rc_params, ...
     'Style','Pop', ...
     'String',choices, ...
     'Callback','rescal(''EnergyUnits'')',...
     'Value',1,...
     'Position',[Tposl+2*Tspaceh Tposb-3*Tspacev 1.5*Twidth Theight]);

hrc_units_current(1)=uicontrol(rc_params, ...
     'Style','Pop', ...
     'String',choices, ...
     'Callback','',...
     'Value',1,...
     'Visible','off',...
     'Position',[Tposl+3*Tspaceh Tposb-3*Tspacev 1.5*Twidth Theight]);


%----- Horizontal FWHM collimations ALF#, #=1,2,3 and 4. (units: minutes of arc) 

hrc_text(11)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ALF1', ...
     'Position',[Tposl Tposb-4*Tspacev Twidth Theight]);

hrc_text(12)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ALF2', ...
     'Position',[Tposl+Tspaceh Tposb-4*Tspacev Twidth Theight]);

hrc_text(13)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ALF3', ...
     'Position',[Tposl+2*Tspaceh Tposb-4*Tspacev Twidth Theight]);

hrc_text(14)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','ALF4', ...
     'Position',[Tposl+3*Tspaceh Tposb-4*Tspacev Twidth Theight]);

hrc_paras(11)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-4*Espacev Ewidth Eheight]);

hrc_paras(12)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-4*Espacev Ewidth Eheight]);

hrc_paras(13)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-4*Espacev Ewidth Eheight]);

hrc_paras(14)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-4*Espacev Ewidth Eheight]);

%----- Vertical FWHM collimations BET#, #=1,2,3 and 4. (units: minutes of arc) 

hrc_text(15)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BET1', ...
     'Position',[Tposl Tposb-5*Tspacev Twidth Theight]);

hrc_text(16)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BET2', ...
     'Position',[Tposl+Tspaceh Tposb-5*Tspacev Twidth Theight]);

hrc_text(17)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BET3', ...
     'Position',[Tposl+2*Tspaceh Tposb-5*Tspacev Twidth Theight]);

hrc_text(18)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BET4', ...
     'Position',[Tposl+3*Tspaceh Tposb-5*Tspacev Twidth Theight]);

hrc_paras(15)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-5*Espacev Ewidth Eheight]);

hrc_paras(16)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-5*Espacev Ewidth Eheight]);

hrc_paras(17)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-5*Espacev Ewidth Eheight]);

hrc_paras(18)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-5*Espacev Ewidth Eheight]);

%----- Lattice Constants  (units: Angstroms) 

hrc_text(19)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','AS', ...
     'Position',[Tposl Tposb-6*Tspacev-Delta Twidth Theight]);

hrc_text(20)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BS', ...
     'Position',[Tposl+Tspaceh Tposb-6*Tspacev-Delta Twidth Theight]);

hrc_text(21)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','CS', ...
     'Position',[Tposl+2*Tspaceh Tposb-6*Tspacev-Delta Twidth Theight]);

hrc_paras(19)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-6*Espacev-Delta Ewidth Eheight]);

hrc_paras(20)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-6*Espacev-Delta Ewidth Eheight]);

hrc_paras(21)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-6*Espacev-Delta Ewidth Eheight]);

%----- Lattice angles  (units: Degrees) 
row=7;

hrc_text(22)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','AA', ...
     'Position',[Tposl Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_text(23)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BB', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_text(24)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','CC', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_paras(22)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-Delta Ewidth Eheight]);

hrc_paras(23)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-Delta Ewidth Eheight]);

hrc_paras(24)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-Delta Ewidth Eheight]);

%----- 1st reciprocal lattices vector to define scattering plane (units: rlu) 
row=8;

hrc_text(25)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','AX', ...
     'Position',[Tposl Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_text(26)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','AY', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_text(27)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','AZ', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_paras(25)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-Delta Ewidth Eheight]);

hrc_paras(26)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-Delta Ewidth Eheight]);

hrc_paras(27)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-Delta Ewidth Eheight]);

%----- 2nd reciprocal lattices vector to define scattering plane (units: rlu) 
row=9;

hrc_text(28)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BX', ...
     'Position',[Tposl Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_text(29)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BY', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_text(30)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','BZ', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-Delta Twidth Theight]);

hrc_paras(28)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-Delta Ewidth Eheight]);

hrc_paras(29)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-Delta Ewidth Eheight]);

hrc_paras(30)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-Delta Ewidth Eheight]);

%----- Spectrometer setting Q,E (units: rlu and meV)
row=10;

hrc_text(31)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','QH', ...
     'Position',[Tposl Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(32)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','QK', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(33)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','QL', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(34)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','EN', ...
     'Position',[Tposl+3*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_paras(31)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(32)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(33)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(34)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

%----- Scan settings DQ,DE (units: rlu and meV)
row=11;

hrc_text(35)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','DH', ...
     'Position',[Tposl Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(36)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','DK', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(37)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','DL', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(38)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','DE', ...
     'Position',[Tposl+3*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_paras(35)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(36)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(37)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(38)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

%----- Phonon dispersion (units: rlu and meV)
row=12;

hrc_text(39)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','GH', ...
     'Position',[Tposl Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(40)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','GK', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(41)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','GL', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_text(42)=uicontrol(rc_params, ...
     'Style','text', ...
     'String','GMOD', ...
     'Position',[Tposl+3*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight]);

hrc_paras(39)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(40)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(41)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

hrc_paras(42)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight]);

%----- Save parameter handles

uicontrol('Visible','off','Tag','hrc_paras','Userdata',hrc_paras);
uicontrol('Visible','off','Tag','hrc_text','Userdata',hrc_text);
uicontrol('Visible','off','Tag','hrc_units_paras','Userdata',hrc_units_paras);
uicontrol('Visible','off','Tag','hrc_units_current','Userdata',hrc_units_current);


%----- Load default paramters to rescal window

rc_getp('pfile','rescal.par');

%----- Start instrument window and add instrument menu

rc_inst;

%----- Load default paramters to instrument window

rc_getp('ifile','rescal.cfg');

%----- Create menu bars

hrc_exit=uimenu(rc_params,'Label','Exit');
uimenu(hrc_exit,'Label','Exit','Callback','rc_exit');

%----- Create File menu bar

hrc_pars=uimenu(rc_params,'Label','Parameters');
uimenu(hrc_pars,'Label','Get parameters','Callback', 'rc_getp(''pfile'')');
uimenu(hrc_pars,'Label','Save parameters','Callback','rc_savp(''pfile'');');
uimenu(hrc_pars,'Label','Load ILL parameters','Callback','rc_illp');

%----- Start method window and set default for Popovici

hrc_rescal_method=uimenu(rc_params,'Label','Method','Tag','hrc_rescal_method');
uimenu(hrc_rescal_method, ...
       'Label',' Cooper-Nathan''s ', ...
       'Callback',[' set(findobj(''Tag'',''hrc_rescal_method''),''Userdata'',''rc_cnmat'');'...
                   ' set(findobj(''Tag'',''Rescal: Instrument''),''Visible'',''off'');']);
uimenu(hrc_rescal_method, ...
       'Label',' Popovici''s ', ...
       'Callback',[' set(findobj(''Tag'',''hrc_rescal_method''),''Userdata'',''rc_popma'');' ...
                   ' set(findobj(''Tag'',''Rescal: Instrument''),''Visible'',''on'');']); 
set(findobj('Tag','hrc_rescal_method'),'Userdata','rc_popma');

if strcmp(option,'initialise')

%----- Create Rescal menu bar

   hrc_rescal=uimenu(rc_params,'Label','Rescal','Tag','hrc_rescal_rescal');
   uimenu(hrc_rescal,'Label','Rescal','Callback','rc_res');
   uimenu(hrc_rescal,'Label','Spectrometer','Callback','rc_spec');
   uimenu(hrc_rescal,'Label','Reciprocal','Callback','rc_scatt');


%----- Create Simulation menu bar

   hrc_sim=uimenu(rc_params,'Label','Simulation','Tag','hrc_rescal_simulation');
   uimenu(hrc_sim,'Label','Simulation','Callback','mc_win');

   return;

end

%----- Check to see if Trix mode is selected by mfit

if strcmp(option,'trixmode')

%----- Change text in main rescal parameter window

   hrc_paras=get(findobj('Tag','hrc_paras'),'Userdata');
   hrc_text=get(findobj('Tag','hrc_text'),'Userdata');
   for i=31:42
      set(hrc_paras(i),'Visible','Off')
      set(hrc_text(i),'Visible','Off')
   end

%----- Create new scan parameter text and edit boxes Hstart, Kstart, Lstart, Estart
   row=10;

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Hstart', ...
     'Position',[Tposl Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');
 
   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Kstart', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Lstart', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Estart', ...
     'Position',[Tposl+3*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   htrix_scan(1)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

   htrix_scan(2)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

   htrix_scan(3)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

   htrix_scan(4)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

%----- scan parameters Hend, Kend, Lend
   row=11;

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Hend', ...
     'Position',[Tposl Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Kend', ...
     'Position',[Tposl+Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','Lend', ...
     'Position',[Tposl+2*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   uicontrol(rc_params, ...
     'Style','text', ...
     'String','End', ...
     'Position',[Tposl+3*Tspaceh Tposb-row*Tspacev-2*Delta Twidth Theight],...
     'Visible','On');

   htrix_scan(5)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

   htrix_scan(6)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

   htrix_scan(7)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+2*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

   htrix_scan(8)=uicontrol(rc_params, ...
     'Style','edit', ...
     'Position',[Eposl+3*Espaceh Eposb-row*Espacev-2*Delta Ewidth Eheight],...
     'Visible','On');

%----- Save handles to  resolution parameters in Tag htrix_scan

   uicontrol('Visible','off','Tag','htrix_scan','Userdata',htrix_scan)


%----- Load default scan paramters

   rc_getp('tfile','rescal.scn');

end

end 

% -- Source Option ---------------

if strcmp(option,'EnergyUnits')

  % disp('Converting!!!')
  % conversion factors

  hrc_paras=get(findobj('Tag','hrc_paras'),'Userdata');
  hrc_units_paras=get(findobj('Tag','hrc_units_paras'),'Userdata');
  newvalue=get(hrc_units_paras(1),'Value');
  hrc_units_current=get(findobj('Tag','hrc_units_current'),'Userdata');
  oldvalue=get(hrc_units_current(1),'Value');

  if newvalue~=oldvalue
    
    % disp(get(hrc_paras(9),'String'))
    kfix=str2num(get(hrc_paras(9),'String'));
    
    % convert from current units to Angs-1
    if oldvalue==2  % meV->Angs-1
      K_angs=sqrt(kfix/2.072);
    elseif oldvalue==3  % THz->Angs-1
      K_angs=sqrt(kfix*4.1357/2.072);
    else 		% Angs-1
      K_angs=kfix;
    end

    % now convert from Angs-1 to new units
    if newvalue==2		% Angs-1 ->meV  
      kfix=2.072*K_angs^2;
    elseif newvalue==3	% Angs-1 ->THz
      kfix=2.072*K_angs^2/4.1357;
    else			% Angs-1
      kfix=K_angs;
    end
    
    set(hrc_units_current(1),'Value',newvalue);
    set(hrc_paras(9),'String',num2str(kfix));
    
  end

end







