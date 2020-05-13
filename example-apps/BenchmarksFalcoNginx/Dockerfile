FROM krisnova/falco-trace:latest
RUN apt-get update && apt-get install stress-ng nginx -y
COPY . .
CMD ["./init.sh"]