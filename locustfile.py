from locust import HttpUser, task

class FibScale(HttpUser):
    @task
    def compute_fibonacci_number(self):
        self.client.post("/", data={"fib": "100", "algorithm": "iterative", "delay": "1"})