# Import necessary libraries
import librosa

# Specify the path to the MP3 file
file_path = "input mp3 file path"  # Specify the path of the MP3 file to analyze

# Load the audio file
y, sr = librosa.load(file_path, sr=None)  # Retain the original sampling rate

# Calculate BPM (tempo)
tempo, _ = librosa.beat.beat_track(y=y, sr=sr)

# Display the result
if isinstance(tempo, (float, int)):  # If the value is scalar
    print(f"The estimated BPM of the audio file is: {tempo:.2f} BPM")
else:  # If the value is an array
    print(f"The estimated BPM of the audio file is: {tempo[0]:.2f} BPM")