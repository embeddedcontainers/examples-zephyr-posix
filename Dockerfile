FROM ghcr.io/embeddedcontainers/zephyr:posix-0.16.4SDK as build

WORKDIR /zephyrproject

COPY west.yml CMakeLists.txt prj.conf /zephyrproject/app/
COPY src/ /zephyrproject/app/src/

RUN \
  west init -l app/ \
  && west update --narrow -o=--depth=1 \
  && west zephyr-export \
  && pip install -r deps/zephyr/scripts/requirements-base.txt \
  && west build -b native_sim app

FROM scratch

COPY --from=build /zephyrproject/build/zephyr/zephyr.exe /bin/zephyr.exe

CMD [ "zephyr.exe" ]