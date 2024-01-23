function my_key = keyConfig(const)
% ----------------------------------------------------------------------
% my_key = keyConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Unify key names and define structure containing each key names
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

KbName('UnifyKeyNames');

my_key.mri_trVal = 't';         % mri trigger letter
my_key.left1Val = 'r';          % left button 1 - not used
my_key.left2Val = 'f';          % left button 2 - not used
my_key.left3Val = 'v';          % left button 3 - not used
my_key.right1Val = 'i';         % right button 1 - pass instructions
my_key.right2Val = 'j';         % right button 2 - not used
my_key.right3Val = 'n';         % right button 3 - not used
my_key.escapeVal = 'escape';    % escape button
my_key.spaceVal = 'space';      % space button

my_key.mri_tr = KbName(my_key.mri_trVal);
my_key.escape = KbName(my_key.escapeVal);
my_key.right1 = KbName(my_key.right1Val);
my_key.space = KbName(my_key.spaceVal);

my_key.keyboard_idx = GetKeyboardIndices;
for keyb = 1:size(my_key.keyboard_idx,2)
    KbQueueCreate(my_key.keyboard_idx(keyb));
    KbQueueFlush(my_key.keyboard_idx(keyb));
    KbQueueStart(my_key.keyboard_idx(keyb));
end
[~, keyCodeMat] = KbQueueCheck(my_key.keyboard_idx(1));
my_key.keyCodeNum = numel(keyCodeMat);

if const.scanner == 1 && ~const.scannerTest
    
    % NI board acquisition settings
    warning off;
    daqreset; % replace daq.reset;
    my_key.ni_devices = daqlist; % replace daq.getDevices
    my_key.ni_session1 = daq(my_key.ni_devices(1).Vendor.ID); % replace daq.createSession
    my_key.ni_session2 = daq(my_key.ni_devices(2).Vendor.ID); % replace daq.createSession
    my_key.ni_device_ID1 = 'Dev1';
    my_key.ni_device_ID2 = 'Dev2';
    my_key.ni_measurement_type = 'InputOnly';
    my_key.button_press_val = 1;
    
    % button press settings
    my_key.port_button_left1 = 'port0/line0'; my_key.idx_button_left1 = 1;
    my_key.port_button_left2 = 'port0/line1'; my_key.idx_button_left2 = 2;
    my_key.port_button_left3 = 'port0/line2'; my_key.idx_button_left3 = 3;    
    if ~isempty(my_key.port_button_left1); my_key.channel_button_left1 = my_key.ni_session2.addDigitalChannel(my_key.ni_device_ID2,my_key.port_button_left1,my_key.ni_measurement_type); end
    if ~isempty(my_key.port_button_left2); my_key.channel_button_left2 = my_key.ni_session2.addDigitalChannel(my_key.ni_device_ID2,my_key.port_button_left2,my_key.ni_measurement_type); end
    if ~isempty(my_key.port_button_left3); my_key.channel_button_left3 = my_key.ni_session2.addDigitalChannel(my_key.ni_device_ID2,my_key.port_button_left3,my_key.ni_measurement_type); end
    
    my_key.port_button_right1 = 'port0/line3'; my_key.idx_button_right1 = 4;
    my_key.port_button_right2 = 'port0/line4'; my_key.idx_button_right2 = 5;
    my_key.port_button_right3 = 'port0/line5'; my_key.idx_button_right3 = 6;   
    if ~isempty(my_key.port_button_right1); my_key.channel_button_right1 = my_key.ni_session2.addDigitalChannel(my_key.ni_device_ID2,my_key.port_button_right1,my_key.ni_measurement_type); end
    if ~isempty(my_key.port_button_right2); my_key.channel_button_right2 = my_key.ni_session2.addDigitalChannel(my_key.ni_device_ID2,my_key.port_button_right2,my_key.ni_measurement_type); end
    if ~isempty(my_key.port_button_right3); my_key.channel_button_right3 = my_key.ni_session2.addDigitalChannel(my_key.ni_device_ID2,my_key.port_button_right3,my_key.ni_measurement_type); end
    
    % MRI trigger settings
    fprintf(1,'\n\n\tDon''t forget to put MRI trigger in "Toggle" mode\n');
    my_key.port_mri_bands = 'port1/line0';
    my_key.idx_mri_bands = 3;
    
    if ~isempty(my_key.port_mri_bands)
        my_key.channel_mri_bands = my_key.ni_session1.addDigitalChannel(my_key.ni_device_ID1,my_key.port_mri_bands,my_key.ni_measurement_type); 
    end
    
    % first reading execution
    my_key.first_val = [my_key.ni_session2.inputSingleScan,...
        my_key.ni_session1.inputSingleScan];
    
else
    my_key.first_val = [0, 0, 0, 0, 0, 0, 0];
end

end