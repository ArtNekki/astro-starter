copy-id-pub:
	pbcopy < ~/.ssh/id_rsa.pub

copy-id:
	pbcopy < ~/.ssh/id_rsa

run:
	doppler run --config dev -- npm run dev
