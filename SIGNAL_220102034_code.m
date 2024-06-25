% Load the audio files
[transmitted, fs] = audioread('normal.wav');
[received, ~] = audioread('echo.wav');

% Preprocess the signals (normalize and remove noise if necessary)
transmitted = transmitted / max(abs(transmitted));
received = received / max(abs(received));

% Plot the signals for visualization
figure;
subplot(2,1,1);
plot(transmitted);
title('normal Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(2,1,2);
plot(received);
title('echo Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

% Cross-correlation to find echoes
[c, lags] = xcorr(received, transmitted);

% Find peaks in the cross-correlation
[~, locs] = findpeaks(c, 'MinPeakHeight', 0.1 * max(c), 'MinPeakDistance', fs/10);

% Calculate the time delays and distances
time_delays = lags(locs) / fs; % Time delays in seconds
speed_of_sound = 450; % Speed of sound in m/s
distances = (time_delays * speed_of_sound) / 2; % Distances in meters

% Display the results
fprintf('Number of mountains detected: %d\n', length(distances));
for i = 1:length(distances)
    fprintf('Distance to mountain %d: %.2f meters\n', i, distances(i));
end

% Determine the attenuation factor
attenuation_factors = zeros(size(distances));
for i = 1:length(distances)
    if lags(locs(i)) > 0
        peak_received = max(received(lags(locs(i)):end));
    else
        peak_received = max(received(1:end+lags(locs(i))));
    end
    peak_transmitted = max(transmitted);
    attenuation_factors(i) = peak_received / peak_transmitted;
    fprintf('Attenuation factor for mountain %d: %.2f\n', i, attenuation_factors(i));
end

% Decision making
if any(distances <= 500)
    fprintf('Batanatham can glide away.\n');
else
    fprintf('Batanatham should call his butler Alfred Reddy for help.\n');
end
