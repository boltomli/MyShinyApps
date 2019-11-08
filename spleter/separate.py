import os
import shutil
import subprocess

from spleeter.separator import Separator
from spleeter.utils.audio.adapter import get_default_audio_adapter

os.environ['PATH'] = os.environ['PATH']+':.'

if not shutil.which('ffprobe'):
    subprocess.check_call(['wget', '-c', 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz'])
    subprocess.check_call(['tar', 'xf', 'ffmpeg-release-amd64-static.tar.xz', '--strip-components=1'])

audio_loader = get_default_audio_adapter()


def load_audio(audio_file):
    waveform, rate = audio_loader.load(audio_file)
    return waveform, rate


def separate(waveform):
    separator = Separator('spleeter:2stems')
    return separator.separate(waveform)


def save_audio(path, instrument, data, rate):
    audio_loader.save(os.path.join(path, f'{instrument}.wav'), data, rate, 'wav', '128k')
