import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile

#wavfile.read()関数を用いて音声ファイルを読み込み最大値域で正規化する。
#音声ファイル*.wavファイルを指定する。パスの前にはrを入れて生値を入力できるようにする。パス内の\をパスの一部と認識させるため。
sampling_freq, signal = wavfile.read(r"wavファイルのパスを入力する")

signal = signal / (2**15)

#信号の長さlen_signalと半分の長さlen_halfを求める。
len_signal = len(signal)
len_half = (len_signal + 1) // 2

#Numpyのfft()関数を用いてフーリエ変換する。
freq_signal = np.fft.fft(signal)

#周波数領域の信号は複素数の配列なのでnp.abs()を用いて振幅を求める。
freq_signal = np.abs(freq_signal[0:len_half]) / len_half

#Y軸の信号パワーをdBに変換する
signal_power = 20 * np.log10(freq_signal)

#グラフのX軸をkHz単位の尺度にする。値域はサンプリング周波数の半分までとする。
x_axis = np.linspace(0, sampling_freq/ 2 /1000.0, len(signal_power))

#グラフを描画する
plt.figure()
plt.title("グラフのタイトルを記載")
plt.xscale("log")
plt.plot(x_axis, signal_power, color = "green")
plt.xlabel("Frequency kHz")
plt.ylabel("Signal Power dB")
plt.show()
