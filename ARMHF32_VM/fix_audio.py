import wave

# Read the raw data (skipping the first 44 bytes of broken header)
with open('output_tone.wav', 'rb') as f:
    f.read(44) # Skip the corrupted header
    raw_audio = f.read()

# Write a perfect new WAV file
print("Writing repaired WAV file...")
with wave.open('fixed_tone.wav', 'wb') as wav_file:
    wav_file.setnchannels(1)       # 1 Channel (Mono)
    wav_file.setsampwidth(2)       # 16-bit PCM (2 bytes)
    wav_file.setframerate(8000)    # 8 kHz Sample Rate
    wav_file.writeframes(raw_audio)

print("Done! You can now play 'fixed_tone.wav'")