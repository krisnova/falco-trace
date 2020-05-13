FROM krisnova/falco-trace:latest
COPY . .
RUN apt-get update && apt-get install ncat -y
EXPOSE 443
CMD ["pdig", "-a", "./init.sh"]