FROM krisnova/falco-trace:latest
COPY . .
RUN apt-get update && apt-get install ncat -y
CMD ["pdig", "-a", "./init.sh"]