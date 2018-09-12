export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export VIRTUALENVWRAPPER_PYTHON=`which python3`
export WORKON_HOME=$HOME/.virtualenvs
source `which virtualenvwrapper.sh`
