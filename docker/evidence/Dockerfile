FROM node:20-slim

WORKDIR /app

# Install dependencies (pages/ and sources/ are mounted at runtime)
COPY package.json ./
RUN npm install --legacy-peer-deps --include=dev

# Copy config (pages/ and sources/ are volume-mounted for live editing)
COPY evidence.config.yaml ./

EXPOSE 3000

# Run sources (pulls data from DuckDB/Nessie) then start dev server
CMD ["sh", "-c", "npm run sources && npm run dev"]