import numpy as np
import librosa
import json

# Load the audio file
audio_path = 'audio.mp3'
y, sr = librosa.load(audio_path)

# Define the number of stages you want
num_stages = 50  # Adjust this value as needed

# Calculate the duration of each stage
audio_duration = librosa.get_duration(y=y, sr=sr)
stage_duration = audio_duration / num_stages

# Generate the stages dynamically
stages = [(i * stage_duration, (i + 1) * stage_duration)
          for i in range(num_stages)]

data = []

for i, (start, end) in enumerate(stages):
    # Convert the start and end times to sample indices
    start_idx = int(start * sr)
    end_idx = int(end * sr)

    # Extract the audio segment
    audio_segment = y[start_idx:end_idx]

    # Calculate the short-term power spectrogram
    S = librosa.feature.melspectrogram(y=audio_segment, sr=sr)
    db = librosa.amplitude_to_db(S, ref=np.max)  # Convert to decibels

    # Calculate the average decibel level for the stage
    avg_db = np.mean(db)

    # Convert decibels to linear scale
    linear_value = 10 ** (avg_db / 20) * 1000

    # Append stage data to the list
    data.append({
        "stage": i+1,
        "start_time": start,
        "end_time": end,
        "linear_value": linear_value,
    })

# Save the data as a JSON file
output_file = 'output.json'
with open(output_file, 'w') as json_file:
    json.dump(data, json_file, indent=4)

print(f"Output saved to {output_file}")
