copy-id-pub:
	pbcopy < ~/.ssh/id_rsa.pub

copy-id:
	pbcopy < ~/.ssh/id_rsa

dev:
	doppler run --config dev -- npm run dev

rm-images:
	docker image prune -af
