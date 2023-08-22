import librosa
import json

# Load the audio file
audio_file_path = 'audio.mp3'
y, sr = librosa.load(audio_file_path)

# Define parameters
interval_duration = 0.1  # Time interval in seconds
hop_length = int(sr * interval_duration)

# Compute sound intensity values
intensity_values = []

for i in range(0, len(y), hop_length):
    audio_segment = y[i:i + hop_length]
    rms_value = librosa.feature.rms(y=audio_segment)[0][0]
    intensity_values.append(
        {
            "intensity": rms_value * 10,
            "end_time": (i+len(audio_segment)) / sr,
        }
    )

max = 0
min = 999999
moy = 0
for elem in intensity_values:
    moy += elem["intensity"]
    if max < elem["intensity"]:
        max = elem["intensity"]
    if min > elem["intensity"] and elem["intensity"] > 1:
        min = elem["intensity"]
moy = moy/len(intensity_values)

print("moy : "+str(moy))
print("max : "+str(max))
print("min : "+str(min))

# Save the data as a JSON file
output_file = 'output.json'
with open(output_file, 'w') as json_file:
    json.dump(intensity_values, json_file, indent=4)

print(f"Output saved to {output_file}")
